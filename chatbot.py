import openai
import pyodbc
import random
from typing import List, Dict
from flask import Flask, render_template, request, jsonify
from flask_cors import CORS

# Thiết lập API key của OpenAI từ environment variable (bảo mật hơn)
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()
openai.api_key = os.getenv('OPENAI_API_KEY', 'your-api-key-here')  # Đọc từ .env file

# Khởi tạo Flask app
app = Flask(__name__)
CORS(app) 

# Connection pool để tối ưu hiệu suất database
import threading
from contextlib import contextmanager

class DatabasePool:
    def __init__(self, max_connections=10):
        self.max_connections = max_connections
        self.connections = []
        self.lock = threading.Lock()

    def get_connection(self):
        with self.lock:
            if self.connections:
                return self.connections.pop()
            else:
                return self._create_connection()

    def return_connection(self, conn):
        with self.lock:
            if len(self.connections) < self.max_connections:
                self.connections.append(conn)
            else:
                conn.close()

    def _create_connection(self):
        try:
            # Sử dụng environment variables cho bảo mật
            server = os.getenv('DB_SERVER', 'localhost')
            database = os.getenv('DB_NAME', 'CraftDB')
            username = os.getenv('DB_USER', 'sa')
            password = os.getenv('DB_PASSWORD', '1234')

            conn = pyodbc.connect(
                f'DRIVER={{ODBC Driver 17 for SQL Server}};'
                f'SERVER={server};'
                f'DATABASE={database};'
                f'UID={username};'
                f'PWD={password};'
                'Connection Timeout=30;'
                'Command Timeout=30;'
            )
            return conn
        except pyodbc.Error as e:
            print(f"Lỗi kết nối database: {e}")
            raise

# Khởi tạo connection pool
db_pool = DatabasePool()

@contextmanager
def get_db_connection():
    """Context manager để quản lý kết nối database an toàn"""
    conn = None
    try:
        conn = db_pool.get_connection()
        yield conn
    except Exception as e:
        if conn:
            conn.rollback()
        raise e
    finally:
        if conn:
            db_pool.return_connection(conn)

# Hàm kết nối database (backward compatibility)
def connect_db():
    """Hàm kết nối database cũ để tương thích"""
    return db_pool.get_connection()

# Simple caching system để tối ưu hiệu suất
import time
from functools import wraps

class SimpleCache:
    def __init__(self, ttl=300):  # 5 minutes TTL
        self.cache = {}
        self.ttl = ttl

    def get(self, key):
        if key in self.cache:
            value, timestamp = self.cache[key]
            if time.time() - timestamp < self.ttl:
                return value
            else:
                del self.cache[key]
        return None

    def set(self, key, value):
        self.cache[key] = (value, time.time())

    def clear(self):
        self.cache.clear()

# Khởi tạo cache instances
product_cache = SimpleCache(ttl=300)  # 5 minutes
village_cache = SimpleCache(ttl=600)  # 10 minutes
stats_cache = SimpleCache(ttl=900)    # 15 minutes

def cache_result(cache_instance, key_prefix=""):
    """Decorator để cache kết quả function"""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            # Tạo cache key từ function name và arguments
            cache_key = f"{key_prefix}{func.__name__}_{hash(str(args) + str(kwargs))}"

            # Thử lấy từ cache trước
            cached_result = cache_instance.get(cache_key)
            if cached_result is not None:
                print(f"Cache hit for {func.__name__}")
                return cached_result

            # Nếu không có trong cache, thực hiện function
            result = func(*args, **kwargs)

            # Lưu vào cache
            cache_instance.set(cache_key, result)
            print(f"Cache miss for {func.__name__}, result cached")

            return result
        return wrapper
    return decorator

# Rate limiting để bảo vệ API
class RateLimiter:
    def __init__(self, max_requests=10, time_window=60):
        self.max_requests = max_requests
        self.time_window = time_window
        self.requests = {}
        self.lock = threading.Lock()

    def is_allowed(self, client_id):
        with self.lock:
            current_time = time.time()

            # Xóa các request cũ
            if client_id in self.requests:
                self.requests[client_id] = [
                    req_time for req_time in self.requests[client_id]
                    if current_time - req_time < self.time_window
                ]
            else:
                self.requests[client_id] = []

            # Kiểm tra giới hạn
            if len(self.requests[client_id]) >= self.max_requests:
                return False

            # Thêm request mới
            self.requests[client_id].append(current_time)
            return True

# Khởi tạo rate limiter
api_rate_limiter = RateLimiter(max_requests=20, time_window=60)  # 20 requests per minute

# Di chuyển hàm remove_diacritics ra ngoài để có thể sử dụng ở nhiều nơi
def remove_diacritics(text):
    """Hàm chuẩn hóa text không dấu"""
    text = text.lower()
    replacements = {
        'đ': 'd', 'á': 'a', 'à': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
        'ă': 'a', 'ắ': 'a', 'ằ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a', 
        'â': 'a', 'ấ': 'a', 'ầ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
        'é': 'e', 'è': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
        'ê': 'e', 'ế': 'e', 'ề': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
        'ó': 'o', 'ò': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
        'ô': 'o', 'ố': 'o', 'ồ': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
        'ơ': 'o', 'ớ': 'o', 'ờ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
        'ú': 'u', 'ù': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
        'ư': 'u', 'ứ': 'u', 'ừ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
        'í': 'i', 'ì': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
        'ý': 'y', 'ỳ': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y'
    }
    for src, dst in replacements.items():
        text = text.replace(src, dst)
    return text

# Thêm một số câu mở đầu ngẫu nhiên để tăng tính đa dạng
def get_greeting() -> str:
    greetings = [
        "Xin chào! ",
        "Chào bạn! ",
        "Rất vui được hỗ trợ bạn! ",
        "Chào mừng bạn đến với làng nghề truyền thống! ",
        "Chào bạn nhé! ",
        ""  # Empty greeting for variety
    ]
    return random.choice(greetings)

def get_response_ending() -> str:
    endings = [
        " Bạn cần thêm thông tin gì nữa không? 😊",
        " Hy vọng thông tin này hữu ích cho bạn!",
        " Bạn có thắc mắc gì thêm không?",
        " Cần tư vấn thêm, bạn cứ hỏi nhé!",
        " Mình có thể giúp gì thêm cho bạn?",
        ""  # Empty ending for variety
    ]
    return random.choice(endings)

# Hàm tìm kiếm sản phẩm nâng cao với thông tin đầy đủ
def search_products(query: str, limit: int = 10) -> List[Dict]:
    conn = connect_db()
    cursor = conn.cursor()

    print(f"Tìm kiếm với query: {query}")

    normalized_query = remove_diacritics(query.lower())

    # Mở rộng từ khóa tìm kiếm
    extended_keywords = {
        "gốm": ["gốm", "sứ", "bát", "đĩa", "chén", "ấm", "bình"],
        "gỗ": ["gỗ", "tượng", "khắc", "chạm", "mộc"],
        "đồng": ["đồng", "chuông", "đúc", "kim loại"],
        "thêu": ["thêu", "dệt", "lụa", "tơ", "vải", "thổ cẩm"],
        "sơn": ["sơn", "mài", "tranh", "khảm"],
        "khảm": ["khảm", "trai", "xà cừ", "ốc"]
    }

    # Tìm từ khóa phù hợp
    search_terms = []
    for main_key, related_terms in extended_keywords.items():
        if any(term in normalized_query for term in related_terms):
            search_terms.extend(related_terms)

    # Nếu không tìm thấy từ khóa cụ thể, tìm kiếm tổng quát
    if not search_terms:
        search_terms = normalized_query.split()

    if not search_terms:
        return []

    # Truy vấn với thông tin đầy đủ từ các bảng liên quan
    conditions = []
    params = []

    for term in search_terms[:5]:  # Giới hạn 5 từ khóa để tránh query quá phức tạp
        conditions.append("""
            (LOWER(p.name) LIKE ?
            OR LOWER(p.description) LIKE ?
            OR LOWER(p.materials) LIKE ?
            OR LOWER(pc.categoryName) LIKE ?
            OR LOWER(cv.villageName) LIKE ?)
        """)
        term_pattern = f"%{term}%"
        params.extend([term_pattern] * 5)

    query_sql = f"""
        SELECT TOP {limit}
            p.pid, p.name, p.price, p.description, p.stock, p.averageRating, p.totalReviews,
            p.materials, p.dimensions, p.weight, p.careInstructions,
            pc.categoryName, cv.villageName, cv.address as villageAddress,
            ct.typeName as craftType
        FROM Product p
        LEFT JOIN ProductCategory pc ON p.categoryID = pc.categoryID
        LEFT JOIN CraftVillage cv ON p.villageID = cv.villageID
        LEFT JOIN CraftType ct ON p.craftTypeID = ct.typeID
        WHERE ({' OR '.join(conditions)}) AND p.status = 1
        ORDER BY p.averageRating DESC, p.totalReviews DESC, p.clickCount DESC
    """

    print(f"Debug - SQL Query: {query_sql}")
    cursor.execute(query_sql, params)

    results = cursor.fetchall()
    print(f"Số sản phẩm tìm thấy: {len(results)}")

    conn.close()

    products = [{
        "pid": row[0],
        "name": row[1],
        "price": float(row[2]),
        "description": row[3],
        "stock": row[4],
        "rating": float(row[5]) if row[5] else 0.0,
        "reviews": row[6] if row[6] else 0,
        "materials": row[7],
        "dimensions": row[8],
        "weight": float(row[9]) if row[9] else 0.0,
        "care_instructions": row[10],
        "category": row[11],
        "village_name": row[12],
        "village_address": row[13],
        "craft_type": row[14]
    } for row in results]

    return products

# Hàm tạo system prompt động dựa trên context
def create_dynamic_system_prompt(context_type: str = "general") -> str:
    """Tạo system prompt phù hợp với từng loại câu hỏi"""

    base_prompt = """Bạn là AI assistant chuyên về làng nghề truyền thống Đà Nẵng và thương mại điện tử sản phẩm thủ công mỹ nghệ.

THÔNG TIN HỆ THỐNG:
- Website bán sản phẩm thủ công từ các làng nghề Đà Nẵng và khu vực lân cận
- Database có các bảng: CraftVillage, Product, ProductCategory, CraftType
- Các danh mục sản phẩm: Gốm sứ, Đồ gỗ, Đồng đúc, Thêu dệt, Sơn mài, Khảm trai
- Các làng nghề nổi tiếng: Nam Ô (nước mắm), Túy Loan (đan lát, bánh tráng), Kim Bồng (gỗ), Thanh Hà (gốm)

NGUYÊN TẮC TRẢ LỜI:
1. CHỈ trả lời về làng nghề Đà Nẵng, sản phẩm thủ công, mua sắm
2. KHÔNG bịa đặt thông tin về làng nghề không có trong database
3. Nếu không biết thông tin cụ thể, hãy thừa nhận và hướng dẫn về các làng nghề có sẵn
4. Trả lời bằng tiếng Việt, thân thiện, chuyên nghiệp
5. Sử dụng emoji phù hợp để tăng tính sinh động
6. Đưa ra thông tin cụ thể về giá, tồn kho, đặc điểm sản phẩm
7. Khuyến khích khách hàng mua sắm một cách tự nhiên

⚠️ QUAN TRỌNG: TUYỆT ĐỐI KHÔNG được bịa đặt thông tin về làng nghề, sản phẩm, hoặc địa điểm không có thật."""

    context_prompts = {
        "product": base_prompt + "\n\nCHUYÊN BIỆT: Tập trung vào thông tin sản phẩm, giá cả, chất lượng, cách sử dụng và bảo quản.",
        "village": base_prompt + "\n\nCHUYÊN BIỆT: Tập trung vào lịch sử, văn hóa, kỹ thuật truyền thống của làng nghề.",
        "comparison": base_prompt + "\n\nCHUYÊN BIỆT: So sánh các sản phẩm, đưa ra lời khuyên mua sắm phù hợp với nhu cầu.",
        "general": base_prompt
    }

    return context_prompts.get(context_type, base_prompt)

# Hàm gọi OpenAI với context-aware prompts
def get_openai_response(prompt: str, context_type: str = "general", max_tokens: int = 300) -> str:
    try:
        # Kiểm tra API key
        if not openai.api_key or openai.api_key == "your-openai-api-key-here":
            print("⚠️ OpenAI API key chưa được cấu hình")
            return "Xin lỗi, hệ thống AI chưa được cấu hình. Vui lòng liên hệ quản trị viên."


        system_prompt = create_dynamic_system_prompt(context_type)

        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt}
            ],
            max_tokens=max_tokens,
            temperature=0.7,
            timeout=30  # Thêm timeout
        )

        if response.choices and len(response.choices) > 0:
            return response.choices[0].message.content
        else:
            return "Xin lỗi, không nhận được phản hồi từ AI. Vui lòng thử lại."

    except Exception as e:
        error_msg = str(e)
        print(f"Lỗi khi gọi OpenAI API: {error_msg}")

        # Xử lý các lỗi cụ thể
        if "api_key" in error_msg.lower():
            return "Xin lỗi, có vấn đề với API key. Vui lòng liên hệ quản trị viên."
        elif "quota" in error_msg.lower() or "billing" in error_msg.lower():
            return "Xin lỗi, hệ thống AI tạm thời quá tải. Vui lòng thử lại sau."
        elif "timeout" in error_msg.lower():
            return "Xin lỗi, kết nối AI bị timeout. Vui lòng thử lại."
        else:
            return "Xin lỗi, hiện tại không thể kết nối với AI để trả lời. Bạn có thể thử lại sau."

# Hàm fallback khi OpenAI không hoạt động
def get_fallback_response(user_input: str, context_type: str = "general") -> str:
    """Trả lời cơ bản khi OpenAI không hoạt động"""
    input_lower = user_input.lower()

    # Phản hồi về làng nghề
    if any(keyword in input_lower for keyword in ["làng nghề", "village", "craft"]):
        return """🏺 **Làng nghề truyền thống Đà Nẵng:**

**Các làng nghề nổi tiếng:**
- **Nam Ô**: Nước mắm truyền thống (400+ năm)
- **Túy Loan**: Đan lát tre nứa, bánh tráng (200+ năm)
- **Kim Bồng**: Đồ gỗ chạm khắc (gần Đà Nẵng)
- **Thanh Hà**: Gốm sứ truyền thống (gần Đà Nẵng)

Bạn có muốn tìm hiểu chi tiết về làng nghề nào không?"""

    # Phản hồi về sản phẩm
    elif any(keyword in input_lower for keyword in ["sản phẩm", "product", "mua", "buy"]):
        return """🛍️ **Sản phẩm thủ công mỹ nghệ:**

**Các danh mục chính:**
- 🏺 Gốm sứ: Bát, đĩa, bình trang trí
- 🪵 Đồ gỗ: Tượng, khay, đồ trang trí
- 🥢 Đan lát: Giỏ, thúng, đồ gia dụng
- 🧵 Thêu dệt: Khăn, túi, quần áo truyền thống

Bạn quan tâm đến loại sản phẩm nào?"""

    # Phản hồi chung
    else:
        return f"""Xin chào! 👋

Mình là chatbot hỗ trợ về làng nghề truyền thống Đà Nẵng.

**Mình có thể giúp bạn:**
- 🏺 Tìm hiểu về các làng nghề
- 🛍️ Tư vấn sản phẩm thủ công
- 💰 Thông tin giá cả
- 📍 Địa điểm tham quan

Bạn có câu hỏi gì về làng nghề Đà Nẵng không?"""

# Cập nhật hàm get_product_info để thêm cảm xúc và câu trả lời tự nhiên
def get_product_info(query: str) -> str:
    """Hàm lấy thông tin chi tiết về sản phẩm"""
    try:
        conn = connect_db()
        cursor = conn.cursor()
        
        normalized_query = remove_diacritics(query.lower())
        
        # Tìm sản phẩm cụ thể
        specific_products = {
            "gốm": "gốm",
            "sứ": "sứ", 
            "bát": "bát",
            "bình": "bình",
            "ấm": "ấm",
            "gỗ": "gỗ",
            "tượng": "tượng",
            "đồng": "đồng",
            "chuông": "chuông",
            "lụa": "lụa",
            "thêu": "thêu",
            "sơn mài": "sơn mài",
            "khảm": "khảm"
        }
        
        for key, value in specific_products.items():
            if key in normalized_query:
                cursor.execute("""
                    SELECT p.name, p.price, p.description, p.stock, c.categoryName
                    FROM Product p
                    JOIN ProductCategory c ON p.categoryID = c.categoryID
                    WHERE LOWER(p.name) LIKE ? AND p.status = 1
                """, f"%{value}%")
                
                result = cursor.fetchone()
                if result:
                    intro = random.choice([
                        f"Về {result[0]} mà bạn hỏi, ",
                        f"Mình xin giới thiệu {result[0]} nhé! ",
                        f"Đây là thông tin về {result[0]} cho bạn: ",
                        f"Về sản phẩm {result[0]} mà bạn quan tâm, "
                    ])
                    
                    stock_status = ""
                    if result[3] > 10:
                        stock_status = f"💯 Còn nhiều hàng ({result[3]} sản phẩm)"
                    elif result[3] > 0:
                        stock_status = f"⚠️ Sắp hết hàng (chỉ còn {result[3]} sản phẩm)"
                    else:
                        stock_status = "❌ Hiện đang hết hàng"
                    
                    return f"""{intro}

🏷️ **{result[0]}**
💰 Giá: {result[1]:,.0f} VND
📋 Mô tả: {result[2]}
📦 Tình trạng: {stock_status}
🏆 Danh mục: {result[4]}

{get_response_ending()}"""
        
        conn.close()
        return None
        
    except Exception as e:
        print(f"Lỗi trong get_product_info: {str(e)}")
        return None

# Cập nhật hàm get_price_info để thêm cảm xúc và phản hồi đa dạng
def get_price_info(query: str) -> str:
    """Hàm lấy thông tin về giá sản phẩm"""
    try:
        conn = connect_db()
        cursor = conn.cursor()
        
        if "mắc nhất" in query or "đắt nhất" in query or "cao nhất" in query:
            cursor.execute("""
                SELECT TOP 3 name, price, description
                FROM Product
                WHERE status = 1
                ORDER BY price DESC
            """)
            results = cursor.fetchall()
            if results:
                intro = random.choice([
                    "Dạ, hiện tại shop có những sản phẩm cao cấp sau: ",
                    "Mình xin chia sẻ top 3 sản phẩm cao cấp nhất của shop: ",
                    "Đây là những sản phẩm có giá cao nhất của shop nhé: ",
                ])
                response = f"{intro}\n\n"
                for i, r in enumerate(results, 1):
                    response += f"{i}. **{r[0]}**: {r[1]:,.0f} VND\n   __{r[2]}__\n\n"
                return response + get_response_ending()
                
        elif "rẻ nhất" in query or "thấp nhất" in query:
            cursor.execute("""
                SELECT TOP 3 name, price, description
                FROM Product
                WHERE status = 1
                ORDER BY price ASC
            """)
            results = cursor.fetchall()
            if results:
                intro = random.choice([
                    "Dạ, hiện tại shop có những sản phẩm giá rẻ sau: ",
                    "Mình xin chia sẻ top 3 sản phẩm giá rẻ nhất của shop: ",
                    "Đây là những sản phẩm có giá thấp nhất của shop nhé: ",
                ])
                response = f"{intro}\n\n"
                for i, r in enumerate(results, 1):
                    response += f"{i}. **{r[0]}**: {r[1]:,.0f} VND\n   __{r[2]}__\n\n"
                return response + get_response_ending()
                
        elif "khoảng giá" in query or "tầm giá" in query:
            cursor.execute("""
                SELECT 
                    MIN(price) as min_price,
                    MAX(price) as max_price,
                    AVG(price) as avg_price
                FROM Product
                WHERE status = 1
            """)
            result = cursor.fetchone()
            if result:
                return f"""
Thông tin khoảng giá sản phẩm thủ công mỹ nghệ:
- Giá thấp nhất: {result[0]:,.0f} VND
- Giá cao nhất: {result[1]:,.0f} VND
- Giá trung bình: {result[2]:,.0f} VND
{get_response_ending()}
                """
        
        conn.close()
        return None
        
    except Exception as e:
        print(f"Lỗi trong get_price_info: {str(e)}")
        return None

# Cập nhật hàm get_products_by_category để hiển thị thông tin đầy đủ và có cấu trúc tốt hơn
def get_products_by_category(category_name: str) -> str:
    """Hàm lấy danh sách sản phẩm theo danh mục"""
    try:
        conn = connect_db()
        cursor = conn.cursor()
        
        # Chuẩn hóa tên category
        normalized_category = remove_diacritics(category_name.lower())
        
        # Map các từ khóa tìm kiếm với categoryID
        category_keywords = {
            "gốm sứ": 1,         # Gốm sứ
            "bát đĩa": 1,        # Thêm từ khóa phụ cho gốm sứ
            "ấm chén": 1,        # Thêm từ khóa phụ cho gốm sứ
            "bình": 1,           # Thêm từ khóa phụ cho gốm sứ
            "đồ gỗ": 2,          # Đồ gỗ
            "tượng": 2,          # Thêm từ khóa phụ cho đồ gỗ
            "khắc gỗ": 2,        # Thêm từ khóa phụ cho đồ gỗ
            "đồng": 3,           # Đồng
            "chuông": 3,         # Thêm từ khóa phụ cho đồng
            "thêu dệt": 4,       # Thêu dệt
            "lụa": 4,            # Thêm từ khóa phụ cho thêu dệt
            "tơ tằm": 4,         # Thêm từ khóa phụ cho thêu dệt
            "sơn mài": 5,        # Sơn mài
            "khảm trai": 6       # Khảm trai
        }
        
        print(f"Đang tìm category với query: {normalized_category}")  # Debug
        
        # Kiểm tra từ khóa cụ thể
        category_id = None
        for key, value in category_keywords.items():
            if key in normalized_category:
                category_id = value
                break
        
        if category_id:
            cursor.execute("""
                SELECT p.name, p.price, p.description, p.stock, c.categoryName
                FROM Product p
                JOIN ProductCategory c ON p.categoryID = c.categoryID
                WHERE c.categoryID = ? AND p.status = 1
                ORDER BY p.price ASC
            """, category_id)
            
            results = cursor.fetchall()
            if results:
                category_name = results[0][4]  # Lấy tên category từ kết quả đầu tiên
                
                # Sử dụng câu mở đầu tốt hơn
                intro = f"""🏺 **Danh mục: {category_name}** 🏺

Mình rất vui được giới thiệu với bạn các sản phẩm thuộc danh mục {category_name} của làng nghề:
"""
                # Format từng sản phẩm rõ ràng hơn
                product_list = ""
                for i, r in enumerate(results, 1):
                    product_list += f"""
✨ **{i}. {r[0]}**
   💰 Giá: {r[1]:,.0f} VND
   📝 {r[2]}
   📦 Tình trạng: {'✅ Còn hàng (' + str(r[3]) + ' sản phẩm)' if r[3] > 0 else '❌ Hết hàng'}
"""
                
                # Thêm lời khuyên phù hợp với danh mục
                tips = {
                    1: "💡 Gốm sứ truyền thống được làm thủ công với kỹ thuật tinh xảo, phù hợp trang trí và sử dụng hàng ngày.",
                    2: "💡 Đồ gỗ được chạm khắc tinh tế, thể hiện văn hóa và nghệ thuật truyền thống Việt Nam.",
                    3: "💡 Đồng được đúc thủ công với hoa văn độc đáo, mang lại vẻ đẹp cổ kính và sang trọng.",
                    4: "💡 Thêu dệt với chất liệu tự nhiên, hoa văn tinh tế thể hiện sự khéo léo của nghệ nhân.",
                    5: "💡 Sơn mài với kỹ thuật độc đáo, tạo nên những tác phẩm nghệ thuật có giá trị cao.",
                    6: "💡 Khảm trai với kỹ thuật tinh xảo, tạo nên những sản phẩm độc đáo và quý giá."
                }
                
                ending = tips.get(category_id, "") + "\n\n" + get_response_ending()
                
                return intro + product_list + ending
                
            else:
                return f"Hiện tại shop chưa có sản phẩm nào trong danh mục {category_name}. Bạn có thể tham khảo các danh mục khác nhé!"
            
        conn.close()
        return f"Xin lỗi, mình không tìm thấy danh mục phù hợp với yêu cầu của bạn. Bạn có thể cho mình biết rõ hơn về sản phẩm bạn đang tìm kiếm không?"
        
    except Exception as e:
        print(f"Lỗi trong get_products_by_category: {str(e)}")
        return f"Xin lỗi bạn! Mình đang gặp chút vấn đề khi tìm kiếm thông tin về danh mục này. Bạn có thể thử lại sau hoặc hỏi về một danh mục khác không?"

def get_category_name(cateID: int, cursor) -> str:
    """Hàm lấy tên danh mục"""
    cursor.execute("SELECT categoryName FROM ProductCategory WHERE categoryID = ?", cateID)
    result = cursor.fetchone()
    return result[0] if result else "Không xác định"

def get_product_recommendations() -> str:
    """Hàm giới thiệu và gợi ý sản phẩm theo danh mục"""
    try:
        conn = connect_db()
        cursor = conn.cursor()
        
        recommendations = """Xin giới thiệu các dòng sản phẩm thủ công mỹ nghệ truyền thống của làng nghề:

1. Gốm sứ truyền thống:
"""
        # Lấy sản phẩm gốm sứ bán chạy
        cursor.execute("""
            SELECT TOP 3 name, price, description 
            FROM Product 
            WHERE categoryID = 1 AND status = 1 
            ORDER BY price DESC
        """)
        results = cursor.fetchall()
        for r in results:
            recommendations += f"   - {r[0]}: {r[1]:,.0f} VND - {r[2]}\n"

        recommendations += "\n2. Đồ gỗ chạm khắc:\n"
        cursor.execute("""
            SELECT TOP 3 name, price, description 
            FROM Product 
            WHERE categoryID = 2 AND status = 1 
            ORDER BY price DESC
        """)
        results = cursor.fetchall()
        for r in results:
            recommendations += f"   - {r[0]}: {r[1]:,.0f} VND - {r[2]}\n"

        recommendations += "\n3. Đồng đúc thủ công:\n"
        cursor.execute("""
            SELECT TOP 3 name, price, description 
            FROM Product 
            WHERE categoryID = 3 AND status = 1 
            ORDER BY price DESC
        """)
        results = cursor.fetchall()
        for r in results:
            recommendations += f"   - {r[0]}: {r[1]:,.0f} VND - {r[2]}\n"

        recommendations += "\n4. Thêu dệt lụa tơ:\n"
        cursor.execute("""
            SELECT TOP 3 name, price, description 
            FROM Product 
            WHERE categoryID = 4 AND status = 1 
            ORDER BY price DESC
        """)
        results = cursor.fetchall()
        for r in results:
            recommendations += f"   - {r[0]}: {r[1]:,.0f} VND - {r[2]}\n"

        recommendations += """
💡 Lời khuyên khi chọn sản phẩm thủ công:
- Gốm sứ: Phù hợp trang trí nhà cửa, quà tặng
- Đồ gỗ: Thể hiện văn hóa truyền thống, trang trí cao cấp
- Đồng: Mang lại vẻ đẹp cổ kính, phù hợp không gian trang trọng
- Thêu dệt: Chất liệu tự nhiên, hoa văn tinh tế, phù hợp thời trang

Bạn có thể cho tôi biết bạn đang quan tâm đến loại nào không?"""

        conn.close()
        return recommendations

    except Exception as e:
        print(f"Lỗi trong get_product_recommendations: {str(e)}")
        return "Xin lỗi, hiện tại không thể lấy được thông tin gợi ý sản phẩm."

# Thêm hàm mới để xử lý câu hỏi về giao hàng và vận chuyển
def get_shipping_info(query: str) -> str:
    """Hàm trả lời các câu hỏi về giao hàng và vận chuyển"""
    query_lower = query.lower()
    
    # Câu hỏi về thời gian giao hàng
    if any(phrase in query_lower for phrase in ["thời gian giao hàng", "mất bao lâu", "khi nào nhận được", "giao trong bao lâu"]):
        return """🚚 **Thông tin về thời gian giao hàng:**

- Nội thành TP.HCM: 1-2 ngày làm việc
- Các tỉnh miền Nam: 2-3 ngày làm việc
- Các tỉnh miền Trung và miền Bắc: 3-5 ngày làm việc
- Khu vực miền núi và hải đảo: 5-7 ngày làm việc

⏰ Lưu ý: Thời gian giao hàng có thể thay đổi tùy theo điều kiện thời tiết và tình trạng vận chuyển.

Bạn có thể cung cấp địa chỉ cụ thể để mình kiểm tra thời gian giao hàng chính xác hơn."""

    # Câu hỏi về phí vận chuyển
    elif any(phrase in query_lower for phrase in ["phí vận chuyển", "phí giao hàng", "ship bao nhiêu", "cước vận chuyển"]):
        return """💰 **Thông tin về phí vận chuyển:**

- Nội thành TP.HCM: 15,000 VND
- Các tỉnh thành khác: 30,000 - 50,000 VND tùy khu vực
- Miễn phí vận chuyển cho đơn hàng từ 500,000 VND

📦 Shop sử dụng các đơn vị vận chuyển uy tín như GHTK, GHN, Viettel Post để đảm bảo hàng đến tay bạn an toàn nhất."""

    # Câu hỏi về hình thức thanh toán
    elif any(phrase in query_lower for phrase in ["thanh toán", "trả tiền", "hình thức thanh toán", "cod"]):
        return """💳 **Các hình thức thanh toán:**

1. Thanh toán khi nhận hàng (COD)
2. Chuyển khoản ngân hàng
3. Ví điện tử (Momo, ZaloPay, VNPay)
4. Thẻ tín dụng/ghi nợ

Bạn có thể chọn phương thức thanh toán phù hợp khi tiến hành đặt hàng nhé!"""

    # Thông tin đổi trả
    elif any(phrase in query_lower for phrase in ["đổi trả", "hoàn tiền", "bảo hành", "đổi sản phẩm"]):
        return """🔄 **Chính sách đổi trả:**

- Thời gian đổi trả: Trong vòng 7 ngày kể từ khi nhận hàng
- Điều kiện: Sản phẩm còn nguyên vẹn, chưa sử dụng, còn đầy đủ bao bì
- Lý do đổi trả: Sản phẩm lỗi, hỏng, không đúng mô tả

⚠️ Lưu ý: Sản phẩm thủ công mỹ nghệ được làm thủ công nên có thể có sự khác biệt nhỏ về màu sắc và kích thước."""
    
    # Không tìm thấy thông tin phù hợp
    return None

# Hàm trả lời ngắn gọn về làng nghề trong web
def get_web_villages_list(query: str = "") -> str:
    """Hàm trả lời ngắn gọn về danh sách làng nghề trong web"""
    try:
        db_villages = get_villages_from_database()
        if not db_villages:
            return "Hiện tại website chưa có thông tin làng nghề nào."
        
        # Lọc theo địa điểm nếu có yêu cầu
        query_lower = query.lower()
        if any(keyword in query_lower for keyword in ["hội an", "hoi an", "hoian"]):
            filtered_villages = [v for v in db_villages if "hoi an" in v['address'].lower() or "quang nam" in v['address'].lower()]
            if filtered_villages:
                response = f"**Website có {len(filtered_villages)} làng nghề ở Hội An:**\n\n"
                villages_to_show = filtered_villages[:5]
            else:
                response = f"**Website có {len(db_villages)} làng nghề (không có ở Hội An):**\n\n"
                villages_to_show = db_villages[:5]
        else:
            response = f"**Website có {len(db_villages)} làng nghề:**\n\n"
            villages_to_show = db_villages[:5]
        
        for i, village in enumerate(villages_to_show, 1):
            rating_stars = "⭐" * int(village['rating']) if village['rating'] > 0 else "Chưa có đánh giá"
            response += f"**{i}. {village['name']}**\n"
            response += f"   📍 {village['address']}\n"
            response += f"   🏆 {village['type']}\n"
            response += f"   ⭐ {village['rating']:.1f}/5.0 ({rating_stars})\n"
            response += f"   📊 {village['reviews']} đánh giá\n\n"
        
        if len(villages_to_show) < len(db_villages):
            response += f"... và {len(db_villages) - len(villages_to_show)} làng nghề khác.\n\n"
        
        response += "Bạn có muốn tìm hiểu chi tiết về làng nghề nào không?"
        return response
        
    except Exception as e:
        print(f"Lỗi trong get_web_villages_list: {str(e)}")
        return "Xin lỗi, có lỗi xảy ra khi lấy thông tin."

# Hàm xử lý thông tin làng nghề Đà Nẵng
def get_danang_village_info() -> str:
    """Hàm xử lý thông tin làng nghề Đà Nẵng - tránh lặp thông tin"""
    try:
        # Lấy thông tin từ database
        db_villages = get_villages_from_database()
        
        # Tạo mapping để so khớp tên làng nghề
        village_mapping = {
            "nam ô": ["nam o", "nam ô", "namo"],
            "túy loan": ["tuy loan", "túy loan", "tuyloan"],
            "kim bồng": ["kim bong", "kim bồng", "kimbong"],
            "thanh hà": ["thanh ha", "thanh hà", "thanhha"],
            "tra quế": ["tra que", "tra quế", "traque"],
            "hoi an": ["hoi an", "hội an", "hoian"]
        }
        
        # Tìm các làng nghề trùng lặp giữa hardcoded và database
        matched_villages = []
        unmatched_db_villages = []
        
        for db_village in db_villages:
            db_name_lower = db_village['name'].lower()
            db_address_lower = db_village['address'].lower()
            
            # Kiểm tra xem có trùng với làng nghề hardcoded không
            is_matched = False
            for hardcoded_name, variations in village_mapping.items():
                for variation in variations:
                    if variation in db_name_lower or variation in db_address_lower:
                        matched_villages.append({
                            'db_village': db_village,
                            'hardcoded_name': hardcoded_name
                        })
                        is_matched = True
                        break
                if is_matched:
                    break
            
            if not is_matched:
                unmatched_db_villages.append(db_village)
        
        # Tạo response thông minh với format đẹp
        response = "🌿 **Làng nghề nổi tiếng ở Đà Nẵng:**\n\n"
        
        # Hiển thị thông tin kết hợp cho các làng trùng lặp
        if matched_villages:
            response += "**🏺 Các làng nghề có sẵn trên website:**\n\n"
            for i, match in enumerate(matched_villages[:5], 1):
                village = match['db_village']
                rating_stars = "⭐" * int(village['rating']) if village['rating'] > 0 else "Chưa có đánh giá"
                
                response += f"**{i}. {village['name']}**\n"
                response += f"   📍 {village['address']}\n"
                response += f"   🏆 Loại: {village['type']}\n"
                response += f"   ⭐ Đánh giá: {village['rating']:.1f}/5.0 ({rating_stars})\n"
                response += f"   📝 {village['description'][:100]}...\n"
                response += f"   📊 {village['reviews']} đánh giá\n\n"
        
        # Hiển thị các làng nghề khác từ database
        if unmatched_db_villages:
            if matched_villages:
                response += "**🌿 Các làng nghề khác trên website:**\n\n"
            else:
                response += "**🏺 Các làng nghề có sẵn trên website:**\n\n"
            
            for i, village in enumerate(unmatched_db_villages[:3], 1):
                rating_stars = "⭐" * int(village['rating']) if village['rating'] > 0 else "Chưa có đánh giá"
                response += f"**{i}. {village['name']}**\n"
                response += f"   📍 {village['address']}\n"
                response += f"   🏆 Loại: {village['type']}\n"
                response += f"   ⭐ Đánh giá: {village['rating']:.1f}/5.0 ({rating_stars})\n"
                response += f"   📊 {village['reviews']} đánh giá\n\n"
        
        # Thêm thông tin tổng kết
        total_villages = len(matched_villages) + len(unmatched_db_villages)
        if total_villages > 0:
            response += f"💡 **Tổng cộng:** Website có {total_villages} làng nghề với đầy đủ thông tin và sản phẩm.\n\n"
        
        response += "Bạn có muốn tìm hiểu chi tiết về làng nghề nào cụ thể không?"
        
        return response
        
    except Exception as e:
        print(f"Lỗi trong get_danang_village_info: {str(e)}")
        return "Xin lỗi, có lỗi xảy ra khi xử lý thông tin. Bạn có thể thử lại sau."

# Hàm xử lý câu hỏi so sánh và đề xuất nâng cao
def get_comparison_and_recommendations(query: str) -> str:
    """Hàm xử lý câu hỏi so sánh và đề xuất sản phẩm với AI thông minh"""
    try:
        # Lấy thông tin từ database
        db_products = search_products(query, limit=5)

        # Tạo context từ database để AI hiểu rõ hơn
        product_context = ""
        if db_products:
            product_context = "THÔNG TIN SẢN PHẨM CÓ SẴN:\n"
            for i, product in enumerate(db_products, 1):
                rating_text = f"{product['rating']:.1f}⭐ ({product['reviews']} đánh giá)" if product['rating'] > 0 else "Chưa có đánh giá"
                product_context += f"""
{i}. {product['name']} - {product['price']:,.0f} VND
   - Danh mục: {product['category']}
   - Làng nghề: {product['village_name']}
   - Đánh giá: {rating_text}
   - Chất liệu: {product['materials'] or 'Không có thông tin'}
   - Tồn kho: {product['stock']} sản phẩm
   - Mô tả: {product['description'][:100]}...
"""

        # Tạo prompt thông minh cho GPT
        enhanced_prompt = f"""
CÂUHỎI KHÁCH HÀNG: "{query}"

{product_context}

Hãy phân tích và đưa ra:
1. 🎯 Phân tích nhu cầu khách hàng từ câu hỏi
2. 💡 So sánh và đánh giá các sản phẩm phù hợp (nếu có)
3. 🛒 Gợi ý sản phẩm cụ thể với lý do
4. 📋 Lời khuyên về cách chọn, sử dụng và bảo quản
5. 💰 Tư vấn về giá cả và tính hiệu quả

Trả lời một cách chuyên nghiệp, thân thiện và thuyết phục khách hàng.
        """

        # Gọi AI với context comparison
        ai_response = get_openai_response(enhanced_prompt, context_type="comparison", max_tokens=400)

        # Tạo response đẹp mắt
        response = f"""🤖 **Tư vấn từ AI chuyên gia:**

{ai_response}

"""

        # Thêm thông tin chi tiết sản phẩm nếu có
        if db_products:
            response += f"""
  **Chi tiết {len(db_products)} sản phẩm phù hợp:**

"""
            for i, product in enumerate(db_products, 1):
                # Tính toán các chỉ số
                rating_display = f"⭐ {product['rating']:.1f}/5.0 ({product['reviews']} đánh giá)" if product['rating'] > 0 else "⭐ Chưa có đánh giá"
                stock_status = "✅ Còn hàng" if product['stock'] > 0 else "❌ Hết hàng"

                response += f"""**{i}. {product['name']}** 🏺
   💰 **Giá:** {product['price']:,.0f} VND
   {rating_display}
   🏪 **Làng nghề:** {product['village_name']}
   📂 **Danh mục:** {product['category']}
   📦 **Tình trạng:** {stock_status} ({product['stock']} sản phẩm)
   🧵 **Chất liệu:** {product['materials'] or 'Thông tin đang cập nhật'}

"""

            response += """
💬 **Cần tư vấn thêm?** Hãy cho tôi biết bạn quan tâm đến sản phẩm nào để được tư vấn chi tiết hơn!"""
        else:
            response += """
🔍 **Không tìm thấy sản phẩm phù hợp trong database.**
Bạn có thể thử tìm kiếm với từ khóa khác hoặc duyệt qua các danh mục sản phẩm của chúng tôi."""

        return response

    except Exception as e:
        print(f"Lỗi trong get_comparison_and_recommendations: {str(e)}")
        return "Xin lỗi, có lỗi xảy ra khi xử lý thông tin. Bạn có thể thử lại sau hoặc liên hệ hỗ trợ."

# Hàm lấy thông tin chi tiết sản phẩm theo ID
def get_product_detail_by_id(product_id: int) -> Dict:
    """Lấy thông tin chi tiết sản phẩm theo ID"""
    try:
        conn = connect_db()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT
                p.pid, p.name, p.price, p.description, p.stock, p.averageRating, p.totalReviews,
                p.materials, p.dimensions, p.weight, p.careInstructions, p.warranty,
                p.sku, p.clickCount, p.createdDate,
                pc.categoryName, cv.villageName, cv.address as villageAddress,
                cv.contactPhone, cv.contactEmail, cv.openingHours,
                ct.typeName as craftType, ct.description as craftTypeDesc
            FROM Product p
            LEFT JOIN ProductCategory pc ON p.categoryID = pc.categoryID
            LEFT JOIN CraftVillage cv ON p.villageID = cv.villageID
            LEFT JOIN CraftType ct ON p.craftTypeID = ct.typeID
            WHERE p.pid = ? AND p.status = 1
        """, product_id)

        result = cursor.fetchone()
        conn.close()

        if result:
            return {
                "pid": result[0],
                "name": result[1],
                "price": float(result[2]),
                "description": result[3],
                "stock": result[4],
                "rating": float(result[5]) if result[5] else 0.0,
                "reviews": result[6] if result[6] else 0,
                "materials": result[7],
                "dimensions": result[8],
                "weight": float(result[9]) if result[9] else 0.0,
                "care_instructions": result[10],
                "warranty": result[11],
                "sku": result[12],
                "click_count": result[13],
                "created_date": result[14],
                "category": result[15],
                "village_name": result[16],
                "village_address": result[17],
                "village_phone": result[18],
                "village_email": result[19],
                "village_hours": result[20],
                "craft_type": result[21],
                "craft_type_desc": result[22]
            }
        return None

    except Exception as e:
        print(f"Lỗi khi lấy chi tiết sản phẩm: {str(e)}")
        return None

# Hàm lấy sản phẩm theo danh mục với thông tin đầy đủ
def get_products_by_category_enhanced(category_name: str, limit: int = 10) -> List[Dict]:
    """Lấy sản phẩm theo danh mục với thông tin đầy đủ"""
    try:
        conn = connect_db()
        cursor = conn.cursor()

        cursor.execute(f"""
            SELECT TOP {limit}
                p.pid, p.name, p.price, p.description, p.stock, p.averageRating, p.totalReviews,
                p.materials, p.dimensions, p.weight,
                pc.categoryName, cv.villageName, cv.address as villageAddress,
                ct.typeName as craftType
            FROM Product p
            LEFT JOIN ProductCategory pc ON p.categoryID = pc.categoryID
            LEFT JOIN CraftVillage cv ON p.villageID = cv.villageID
            LEFT JOIN CraftType ct ON p.craftTypeID = ct.typeID
            WHERE LOWER(pc.categoryName) LIKE ? AND p.status = 1
            ORDER BY p.averageRating DESC, p.totalReviews DESC
        """, f"%{category_name.lower()}%")

        results = cursor.fetchall()
        conn.close()

        products = [{
            "pid": row[0],
            "name": row[1],
            "price": float(row[2]),
            "description": row[3],
            "stock": row[4],
            "rating": float(row[5]) if row[5] else 0.0,
            "reviews": row[6] if row[6] else 0,
            "materials": row[7],
            "dimensions": row[8],
            "weight": float(row[9]) if row[9] else 0.0,
            "category": row[10],
            "village_name": row[11],
            "village_address": row[12],
            "craft_type": row[13]
        } for row in results]

        return products

    except Exception as e:
        print(f"Lỗi khi lấy sản phẩm theo danh mục: {str(e)}")
        return []

# Hàm lấy thông tin làng nghề từ database với caching
@cache_result(village_cache, "villages_")
def get_villages_from_database() -> List[Dict]:
    """Hàm lấy danh sách làng nghề từ database"""
    try:
        conn = connect_db()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT v.villageID, v.villageName, v.description, v.address, 
                   v.averageRating, v.totalReviews, ct.typeName
            FROM CraftVillage v
            LEFT JOIN CraftType ct ON v.typeID = ct.typeID
            WHERE v.status = 1
            ORDER BY v.averageRating DESC, v.totalReviews DESC
        """)
        
        results = cursor.fetchall()
        conn.close()
        
        villages = [{
            "id": row[0],
            "name": row[1],
            "description": row[2],
            "address": row[3],
            "rating": float(row[4]) if row[4] else 0.0,
            "reviews": row[5],
            "type": row[6] if row[6] else "Không xác định"
        } for row in results]
        
        return villages
    except Exception as e:
        print(f"Lỗi khi lấy dữ liệu làng nghề từ database: {str(e)}")
        return []

# Hàm lấy thống kê tổng quan từ database với caching
@cache_result(stats_cache, "stats_")
def get_database_statistics() -> Dict:
    """Lấy thống kê tổng quan về sản phẩm và làng nghề"""
    try:
        conn = connect_db()
        cursor = conn.cursor()

        # Thống kê sản phẩm
        cursor.execute("""
            SELECT
                COUNT(*) as total_products,
                AVG(price) as avg_price,
                MIN(price) as min_price,
                MAX(price) as max_price,
                SUM(stock) as total_stock,
                AVG(averageRating) as avg_rating
            FROM Product
            WHERE status = 1
        """)
        product_stats = cursor.fetchone()

        # Thống kê theo danh mục
        cursor.execute("""
            SELECT pc.categoryName, COUNT(*) as product_count, AVG(p.price) as avg_price
            FROM Product p
            JOIN ProductCategory pc ON p.categoryID = pc.categoryID
            WHERE p.status = 1
            GROUP BY pc.categoryName
            ORDER BY product_count DESC
        """)
        category_stats = cursor.fetchall()

        # Thống kê làng nghề
        cursor.execute("""
            SELECT
                COUNT(*) as total_villages,
                AVG(averageRating) as avg_village_rating,
                SUM(totalReviews) as total_reviews
            FROM CraftVillage
            WHERE status = 1
        """)
        village_stats = cursor.fetchone()

        # Top sản phẩm được đánh giá cao
        cursor.execute("""
            SELECT TOP 5 name, price, averageRating, totalReviews
            FROM Product
            WHERE status = 1 AND averageRating > 0
            ORDER BY averageRating DESC, totalReviews DESC
        """)
        top_products = cursor.fetchall()

        conn.close()

        return {
            "products": {
                "total": product_stats[0] if product_stats[0] else 0,
                "avg_price": float(product_stats[1]) if product_stats[1] else 0.0,
                "min_price": float(product_stats[2]) if product_stats[2] else 0.0,
                "max_price": float(product_stats[3]) if product_stats[3] else 0.0,
                "total_stock": product_stats[4] if product_stats[4] else 0,
                "avg_rating": float(product_stats[5]) if product_stats[5] else 0.0
            },
            "categories": [{"name": row[0], "count": row[1], "avg_price": float(row[2])} for row in category_stats],
            "villages": {
                "total": village_stats[0] if village_stats[0] else 0,
                "avg_rating": float(village_stats[1]) if village_stats[1] else 0.0,
                "total_reviews": village_stats[2] if village_stats[2] else 0
            },
            "top_products": [{"name": row[0], "price": float(row[1]), "rating": float(row[2]), "reviews": row[3]} for row in top_products]
        }

    except Exception as e:
        print(f"Lỗi khi lấy thống kê database: {str(e)}")
        return {}

# Hàm tạo báo cáo thống kê cho AI
def generate_statistics_report() -> str:
    """Tạo báo cáo thống kê để AI hiểu rõ hơn về database"""
    try:
        stats = get_database_statistics()
        if not stats:
            return "Không thể lấy thống kê từ database."

        report = f"""📊 **THỐNG KÊ HỆ THỐNG LÀNG NGHỀ ĐÀ NẴNG**

🏺 **Sản phẩm:**
- Tổng số: {stats['products']['total']} sản phẩm
- Giá trung bình: {stats['products']['avg_price']:,.0f} VND
- Khoảng giá: {stats['products']['min_price']:,.0f} - {stats['products']['max_price']:,.0f} VND
- Tổng tồn kho: {stats['products']['total_stock']} sản phẩm
- Đánh giá trung bình: {stats['products']['avg_rating']:.1f}/5.0 ⭐

🏪 **Làng nghề:**
- Tổng số: {stats['villages']['total']} làng nghề
- Đánh giá trung bình: {stats['villages']['avg_rating']:.1f}/5.0 ⭐
- Tổng đánh giá: {stats['villages']['total_reviews']} đánh giá

📂 **Danh mục sản phẩm:**"""

        for cat in stats['categories']:
            report += f"\n- {cat['name']}: {cat['count']} sản phẩm (giá TB: {cat['avg_price']:,.0f} VND)"

        if stats['top_products']:
            report += f"\n\n🏆 **Top sản phẩm được yêu thích:**"
            for i, product in enumerate(stats['top_products'], 1):
                report += f"\n{i}. {product['name']} - {product['price']:,.0f} VND (⭐ {product['rating']:.1f}, {product['reviews']} đánh giá)"

        return report

    except Exception as e:
        print(f"Lỗi khi tạo báo cáo thống kê: {str(e)}")
        return "Không thể tạo báo cáo thống kê."

# Hàm kiểm tra làng nghề có tồn tại trong database không
def check_village_exists(location_name: str) -> bool:
    """Kiểm tra xem làng nghề có tồn tại trong database không"""
    try:
        conn = connect_db()
        cursor = conn.cursor()

        # Chuẩn hóa tên địa điểm
        normalized_location = remove_diacritics(location_name.lower())

        # Kiểm tra trong bảng CraftVillage
        cursor.execute("""
            SELECT COUNT(*) FROM CraftVillage
            WHERE LOWER(villageName) LIKE ?
            OR LOWER(address) LIKE ?
            AND status = 1
        """, f"%{normalized_location}%", f"%{normalized_location}%")

        count = cursor.fetchone()[0]
        conn.close()

        return count > 0

    except Exception as e:
        print(f"Lỗi khi kiểm tra làng nghề: {str(e)}")
        return False

# Hàm xử lý câu hỏi về làng nghề không có trong database
def handle_unknown_village_question(user_input: str) -> str:
    """Xử lý câu hỏi về làng nghề không có trong database"""

    # Trích xuất tên địa điểm từ câu hỏi
    input_lower = user_input.lower()

    # Danh sách các làng nghề có thật trong database
    known_villages = [
        "Nam Ô", "Túy Loan", "Kim Bồng", "Thanh Hà",
        "Hội An", "Đà Nẵng", "Quảng Nam"
    ]

    return f"""Xin lỗi, mình không có thông tin cụ thể về làng nghề tại địa điểm bạn hỏi trong database hiện tại.

🏺 **Các làng nghề mình có thông tin chi tiết:**

**Tại Đà Nẵng:**
- **Nam Ô**: Nước mắm truyền thống (400+ năm)
- **Túy Loan**: Đan lát tre nứa, bánh tráng (200+ năm)

**Gần Đà Nẵng (Hội An, Quảng Nam):**
- **Kim Bồng**: Đồ gỗ chạm khắc (400+ năm)
- **Thanh Hà**: Gốm sứ truyền thống (400+ năm)

💡 **Gợi ý:** Bạn có muốn tìm hiểu về các làng nghề này không? Hoặc bạn có thể xem các sản phẩm thủ công có sẵn trên website.

🛍️ **Sản phẩm có sẵn:** Website hiện có sản phẩm từ 9 làng nghề với đầy đủ thông tin và đánh giá từ khách hàng."""

# Hàm phân tích sentiment của câu hỏi
def analyze_user_sentiment(user_input: str) -> Dict:
    """Phân tích cảm xúc và ý định của người dùng"""
    input_lower = user_input.lower()

    # Phân tích ý định mua hàng
    buying_intent_keywords = ["mua", "đặt hàng", "order", "cần", "muốn có", "quan tâm", "thích"]
    buying_intent = any(keyword in input_lower for keyword in buying_intent_keywords)

    # Phân tích cảm xúc tích cực/tiêu cực
    positive_keywords = ["đẹp", "tốt", "chất lượng", "thích", "yêu", "tuyệt", "xuất sắc", "hoàn hảo"]
    negative_keywords = ["xấu", "tệ", "kém", "không thích", "ghét", "tồi", "dở"]

    positive_score = sum(1 for keyword in positive_keywords if keyword in input_lower)
    negative_score = sum(1 for keyword in negative_keywords if keyword in input_lower)

    # Phân tích loại câu hỏi
    question_types = {
        "price": ["giá", "bao nhiêu", "tiền", "cost", "price"],
        "quality": ["chất lượng", "tốt", "xấu", "đẹp", "quality"],
        "comparison": ["so sánh", "khác", "nào tốt", "compare"],
        "information": ["thông tin", "chi tiết", "mô tả", "info"],
        "recommendation": ["gợi ý", "tư vấn", "recommend", "suggest"]
    }

    detected_types = []
    for q_type, keywords in question_types.items():
        if any(keyword in input_lower for keyword in keywords):
            detected_types.append(q_type)

    return {
        "buying_intent": buying_intent,
        "sentiment_score": positive_score - negative_score,
        "sentiment": "positive" if positive_score > negative_score else "negative" if negative_score > positive_score else "neutral",
        "question_types": detected_types,
        "urgency": any(keyword in input_lower for keyword in ["gấp", "nhanh", "urgent", "asap"])
    }

# Hàm gợi ý sản phẩm thông minh dựa trên AI
def get_smart_product_recommendations(user_input: str, user_sentiment: Dict) -> str:
    """Gợi ý sản phẩm thông minh dựa trên phân tích AI"""
    try:
        # Lấy sản phẩm từ database
        products = search_products(user_input, limit=8)

        if not products:
            return "Xin lỗi, hiện tại không tìm thấy sản phẩm phù hợp. Bạn có thể thử tìm kiếm với từ khóa khác."

        # Tạo context cho AI
        stats = get_database_statistics()

        ai_context = f"""
PHÂN TÍCH NGƯỜI DÙNG:
- Câu hỏi: "{user_input}"
- Ý định mua hàng: {"Cao" if user_sentiment['buying_intent'] else "Thấp"}
- Cảm xúc: {user_sentiment['sentiment']} (điểm: {user_sentiment['sentiment_score']})
- Loại câu hỏi: {', '.join(user_sentiment['question_types'])}
- Mức độ khẩn cấp: {"Cao" if user_sentiment['urgency'] else "Bình thường"}

THỐNG KÊ HỆ THỐNG:
- Tổng sản phẩm: {stats.get('products', {}).get('total', 0)}
- Giá trung bình: {stats.get('products', {}).get('avg_price', 0):,.0f} VND
- Đánh giá TB: {stats.get('products', {}).get('avg_rating', 0):.1f}/5.0

SẢN PHẨM PHÙHỢP:
"""

        for i, product in enumerate(products[:5], 1):
            ai_context += f"""
{i}. {product['name']} - {product['price']:,.0f} VND
   - Đánh giá: {product['rating']:.1f}⭐ ({product['reviews']} đánh giá)
   - Tồn kho: {product['stock']} sản phẩm
   - Làng nghề: {product['village_name']}
   - Danh mục: {product['category']}
"""

        ai_prompt = f"""
{ai_context}

Hãy phân tích và đưa ra:
1. 🎯 Gợi ý 2-3 sản phẩm phù hợp nhất với nhu cầu
2. 💡 Lý do tại sao những sản phẩm này phù hợp
3. 💰 Phân tích giá cả và tính hiệu quả
4. 🛒 Chiến lược bán hàng phù hợp với tâm lý khách hàng
5. 📞 Call-to-action thuyết phục

Trả lời thân thiện, chuyên nghiệp và thuyết phục.
        """

        ai_response = get_openai_response(ai_prompt, context_type="product", max_tokens=500)

        # Format response đẹp
        response = f"""🤖 **Gợi ý thông minh từ AI:**

{ai_response}

📋 **Chi tiết sản phẩm được đề xuất:**

"""

        # Hiển thị top 3 sản phẩm
        for i, product in enumerate(products[:3], 1):
            rating_display = f"⭐ {product['rating']:.1f}/5.0 ({product['reviews']} đánh giá)" if product['rating'] > 0 else "⭐ Chưa có đánh giá"
            stock_status = "✅ Còn hàng" if product['stock'] > 0 else "❌ Hết hàng"

            response += f"""**{i}. {product['name']}** 🏺
💰 **Giá:** {product['price']:,.0f} VND
{rating_display}
🏪 **Làng nghề:** {product['village_name']}
📦 **Tình trạng:** {stock_status} ({product['stock']} sản phẩm)
🧵 **Chất liệu:** {product['materials'] or 'Đang cập nhật'}

"""

        # Thêm call-to-action dựa trên sentiment
        if user_sentiment['buying_intent']:
            response += "🛒 **Sẵn sàng đặt hàng?** Hãy cho tôi biết sản phẩm nào bạn quan tâm để được hỗ trợ đặt hàng!"
        else:
            response += "💬 **Cần tư vấn thêm?** Tôi có thể giải đáp mọi thắc mắc về sản phẩm, giá cả, chất lượng!"

        return response

    except Exception as e:
        print(f"Lỗi trong get_smart_product_recommendations: {str(e)}")
        return "Xin lỗi, có lỗi xảy ra khi tạo gợi ý. Bạn có thể thử lại sau."

# Hàm gọi GPT để lấy thông tin làng nghề từ internet
def get_villages_from_gpt(query: str) -> str:
    """Hàm gọi GPT để lấy thông tin làng nghề từ internet"""
    try:
        from openai import OpenAI
        client = OpenAI(api_key=openai.api_key)
        
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "Bạn là chuyên gia về làng nghề truyền thống Đà Nẵng. Chỉ cung cấp thông tin về các làng nghề ở Đà Nẵng và khu vực lân cận (Hội An, Quảng Nam). Trả lời bằng tiếng Việt, cung cấp thông tin chi tiết về tên làng nghề, địa điểm, lịch sử, đặc sản, kỹ thuật truyền thống và điểm nổi bật. Nếu câu hỏi không liên quan đến làng nghề Đà Nẵng, hãy từ chối và hướng dẫn về chủ đề làng nghề Đà Nẵng."},
                {"role": "user", "content": query}
            ],
            max_tokens=500,
            temperature=0.7
        )
        return response.choices[0].message.content
    except Exception as e:
        print(f"Lỗi khi gọi GPT API: {str(e)}")
        return "Không thể lấy thông tin từ internet. Bạn có thể tham khảo thông tin từ database."

# Hàm kết hợp thông tin từ database và GPT
def get_combined_village_info(query: str) -> str:
    """Hàm kết hợp thông tin từ database và GPT"""
    try:
        # Lấy thông tin từ database
        db_villages = get_villages_from_database()
        
        # Lấy thông tin từ GPT
        gpt_info = get_villages_from_gpt(query)
        
        # Tạo response kết hợp
        if gpt_info and gpt_info != "Không thể lấy thông tin từ internet. Bạn có thể tham khảo thông tin từ database.":
            response = f"""🌿 **Thông tin làng nghề từ internet:**

{gpt_info}

"""
        else:
            response = """🌿 **Thông tin làng nghề Đà Nẵng:**

Dựa trên kiến thức về các làng nghề truyền thống Đà Nẵng, đây là một số làng nghề nổi tiếng:

**Làng nghề nước mắm Nam Ô (Đà Nẵng):**
- Địa điểm: Phường Nam Ô, quận Liên Chiểu
- Lịch sử: Hơn 400 năm tuổi
- Đặc sản: Nước mắm truyền thống, mắm ruốc
- Kỹ thuật: Ủ cá cơm sọc tiêu với muối biển

**Làng nghề đan lát Túy Loan (Đà Nẵng):**
- Địa điểm: Xã Hòa Phong, huyện Hòa Vang
- Lịch sử: Hơn 200 năm tuổi
- Đặc sản: Đồ đan lát từ tre, nứa
- Kỹ thuật: Đan lát thủ công tinh xảo

**Làng nghề gốm Thanh Hà (Hội An - gần Đà Nẵng):**
- Địa điểm: Xã Cẩm Hà, Hội An (cách Đà Nẵng 30km)
- Lịch sử: Hơn 400 năm tuổi
- Đặc sản: Gốm đất nung, đồ trang trí
- Kỹ thuật: Nung bằng củi, không men

"""
        
        # Thêm thông tin về các làng nghề có trên web
        if db_villages:
            response += f"""
🏺 **Các làng nghề có sẵn trên website ({len(db_villages)} làng nghề):**

"""
            for i, village in enumerate(db_villages[:5], 1):  # Hiển thị top 5
                rating_stars = "⭐" * int(village['rating']) if village['rating'] > 0 else "Chưa có đánh giá"
                response += f"""{i}. **{village['name']}**
   📍 {village['address']}
   🏆 Loại: {village['type']}
   ⭐ Đánh giá: {village['rating']:.1f}/5.0 ({rating_stars})
   📝 {village['description'][:100]}...
   📊 {village['reviews']} đánh giá

"""
            
            response += f"""
💡 **So sánh:** Trong số các làng nghề nổi tiếng được đề cập, website hiện có {len(db_villages)} làng nghề với đầy đủ thông tin và sản phẩm để bạn tham khảo và mua sắm.

Bạn có muốn tìm hiểu chi tiết về làng nghề nào cụ thể không?"""
        
        return response
        
    except Exception as e:
        print(f"Lỗi trong get_combined_village_info: {str(e)}")
        return "Xin lỗi, có lỗi xảy ra khi xử lý thông tin. Bạn có thể thử lại sau."

# Thêm hàm mới để xử lý câu hỏi về làng nghề
def get_village_info(query: str) -> str:
    """Hàm trả lời các câu hỏi về làng nghề"""
    query_lower = query.lower()
    
    # Xử lý câu hỏi về làng nghề theo địa phương
    if any(phrase in query_lower for phrase in ["đà nẵng", "da nang", "danang"]):
        return get_danang_village_info()
    
    elif any(phrase in query_lower for phrase in ["hà nội", "ha noi", "hanoi"]):
        return "Xin lỗi, mình chỉ chuyên về làng nghề Đà Nẵng và khu vực lân cận. Bạn có muốn tìm hiểu về các làng nghề nổi tiếng ở Đà Nẵng không?"
    
    elif any(phrase in query_lower for phrase in ["hội an", "hoi an", "hoian"]):
        return get_combined_village_info("Liệt kê 5 làng nghề nổi tiếng nhất ở Hội An với thông tin chi tiết về lịch sử, đặc sản và kỹ thuật truyền thống")
    
    elif any(phrase in query_lower for phrase in ["huế", "hue"]):
        return "Xin lỗi, mình chỉ chuyên về làng nghề Đà Nẵng và khu vực lân cận. Bạn có muốn tìm hiểu về các làng nghề nổi tiếng ở Đà Nẵng không?"
    
    # Câu hỏi về làng nghề gốm
    elif any(phrase in query_lower for phrase in ["làng gốm", "gốm bát tràng", "gốm thanh hà"]):
        return get_combined_village_info("Liệt kê các làng nghề gốm sứ nổi tiếng ở Đà Nẵng và Hội An với thông tin chi tiết về lịch sử, đặc sản và kỹ thuật truyền thống")
    
    # Câu hỏi về làng nghề thêu
    elif any(phrase in query_lower for phrase in ["làng thêu", "thêu quất động", "thêu xứ quảng"]):
        return get_combined_village_info("Liệt kê các làng nghề thêu dệt nổi tiếng ở Đà Nẵng và khu vực lân cận với thông tin chi tiết về lịch sử, đặc sản và kỹ thuật truyền thống")
    
    # Câu hỏi về làng nghề gỗ
    elif any(phrase in query_lower for phrase in ["làng gỗ", "gỗ kim bong", "chạm khắc gỗ"]):
        return get_combined_village_info("Liệt kê các làng nghề gỗ chạm khắc nổi tiếng ở Đà Nẵng và Hội An với thông tin chi tiết về lịch sử, đặc sản và kỹ thuật truyền thống")
    
    # Câu hỏi chung về làng nghề
    elif any(phrase in query_lower for phrase in ["làng nghề", "làng nghề nổi tiếng", "làng nghề truyền thống"]):
        return get_combined_village_info("Liệt kê 10 làng nghề truyền thống nổi tiếng nhất ở Đà Nẵng và khu vực lân cận với thông tin chi tiết về lịch sử, đặc sản và kỹ thuật truyền thống")
    
    # Không tìm thấy thông tin phù hợp
    return None

# Cập nhật hàm chatbot_response với AI thông minh
def chatbot_response(user_input: str) -> str:
    try:
        input_lower = user_input.lower()
        greeting = get_greeting()

        # Phân tích sentiment và ý định người dùng
        try:
            user_sentiment = analyze_user_sentiment(user_input)
            print(f"Debug - User sentiment: {user_sentiment}")  # Debug
        except Exception as e:
            print(f"Lỗi trong analyze_user_sentiment: {str(e)}")
            user_sentiment = {
                "buying_intent": False,
                "sentiment_score": 0,
                "sentiment": "neutral",
                "question_types": [],
                "urgency": False
            }

        # Kiểm tra câu hỏi về làng nghề không có trong database - ưu tiên cao nhất
        if any(location in input_lower for location in ["điện ngọc", "điện bàn", "tam kỳ", "núi thành", "thăng bình", "chu đậu"]):
            return f"{greeting}{handle_unknown_village_question(user_input)}"

        # Xử lý câu hỏi về thống kê hệ thống
        if any(keyword in input_lower for keyword in ["thống kê", "báo cáo", "tổng quan", "statistics", "overview"]):
            return f"{greeting}{generate_statistics_report()}"

        # Xử lý câu hỏi về web có làng nghề nào - ưu tiên cao nhất
        if any(keyword in input_lower for keyword in ["web site", "website", "web có", "website có", "trong web", "trong website", "có sẵn", "có trong", "danh sách", "liệt kê", "các làng nghề", "web đang có", "website đang có"]):
            if any(keyword in input_lower for keyword in ["có", "có gì", "có những", "có các", "đang có"]):
                return f"{greeting}{get_web_villages_list(user_input)}"
        
        # Xử lý câu hỏi về mua hàng/địa điểm mua - ưu tiên cao
        if any(keyword in input_lower for keyword in ["mua ở đâu", "ở đâu", "địa điểm mua", "shop", "cửa hàng", "đặt hàng"]) or ("mua" in input_lower and "đâu" in input_lower):
            return f"""{greeting}🛒 **Địa điểm mua sản phẩm làng nghề Đà Nẵng:**

**1. 🌐 Trên website này:**
- Bạn đang truy cập website chính thức bán sản phẩm làng nghề
- Có đầy đủ sản phẩm từ 9 làng nghề với giá cả minh bạch
- Hỗ trợ đặt hàng online và giao hàng toàn quốc
- Đánh giá từ khách hàng thực tế

**2. 🏪 Tại các làng nghề:**
- **Nam Ô** (Đà Nẵng): Nước mắm, mắm ruốc
- **Túy Loan** (Đà Nẵng): Đồ đan lát, bánh tráng
- **Kim Bồng** (Hội An): Đồ gỗ chạm khắc
- **Thanh Hà** (Hội An): Gốm sứ truyền thống

**3. 🏬 Các cửa hàng lưu niệm:**
- Chợ Hàn, Chợ Cồn (Đà Nẵng)
- Phố cổ Hội An
- Các resort và khách sạn

💡 **Khuyến nghị:** Mua trên website này để đảm bảo chất lượng và giá tốt nhất!

Bạn muốn xem sản phẩm nào cụ thể không? 🛍️"""

        # Xử lý câu hỏi về Nam Ô cụ thể
        elif any(keyword in input_lower for keyword in ["nam ô", "nam o", "nước mắm nam ô"]):
            return f"""{greeting}🏺 **Làng nghề nước mắm Nam Ô - Đặc sản Đà Nẵng:**

**📍 Thông tin cơ bản:**
- **Địa điểm**: Phường Nam Ô, quận Liên Chiểu, Đà Nẵng
- **Lịch sử**: Hơn 400 năm truyền thống làm nước mắm
- **Đặc sản nổi tiếng**: Nước mắm Nam Ô, mắm ruốc, mắm tôm

**🥢 Sản phẩm đặc trưng:**
- **Nước mắm truyền thống**: Được ủ từ cá cơm sọc tiêu tươi ngon
- **Mắm ruốc**: Đặc sản độc đáo của vùng biển Đà Nẵng
- **Mắm tôm**: Chất lượng cao, hương vị đậm đà

**⚗️ Quy trình sản xuất:**
- Sử dụng cá cơm sọc tiêu tươi ngon nhất
- Ủ với muối biển tự nhiên trong thùng gỗ
- Thời gian ủ từ 12-18 tháng để có chất lượng tốt nhất
- Không sử dụng chất bảo quản, hoàn toàn tự nhiên

**🏆 Đặc điểm nổi bật:**
- Màu nâu hổ phách đẹp mắt
- Vị ngọt thanh, mặn vừa phải
- Mùi thơm đặc trưng, không tanh
- Được công nhận là sản phẩm OCOP 3 sao

**🛒 Mua sản phẩm Nam Ô:**
- Trực tiếp tại làng nghề Nam Ô
- Trên website này với giá ưu đãi
- Các cửa hàng đặc sản Đà Nẵng

Bạn có muốn xem các sản phẩm nước mắm Nam Ô có sẵn không? 🍯"""

        # Xử lý câu hỏi về làng nghề cụ thể khác (không trùng với câu hỏi mua hàng)
        elif any(keyword in input_lower for keyword in ["làng nghề", "làng gốm", "làng thêu", "làng gỗ", "bát tràng", "thanh hà", "quất động", "kim bồng"]) and not any(keyword in input_lower for keyword in ["mua", "shop", "website"]):
            village_info = get_village_info(input_lower)
            if village_info:
                return f"{greeting}{village_info}"
        
        # Kiểm tra xem có phải đang tìm một sản phẩm cụ thể không
        if any(keyword in input_lower for keyword in ["gốm", "sứ", "gỗ", "đồng", "thêu", "dệt", "lụa", "tượng", "bình", "bát"]):
            product_info = get_product_info(input_lower)
            if product_info:
                return product_info
        
        # Thêm điều kiện xử lý câu hỏi về giá
        if any(keyword in input_lower for keyword in ["mắc nhất", "đắt nhất", "rẻ nhất", "khoảng giá", "tầm giá", "cao nhất", "thấp nhất", "giá bao nhiêu", "bao nhiêu tiền"]):
            price_info = get_price_info(input_lower)
            if price_info:
                return f"{greeting}{price_info}"
                
        # Xử lý yêu cầu gợi ý sản phẩm thông minh
        if any(keyword in input_lower for keyword in ["giới thiệu", "loại nào tốt", "gợi ý", "tư vấn", "quan tâm", "recommend"]):
            # Sử dụng AI thông minh để gợi ý
            return f"{greeting}{get_smart_product_recommendations(user_input, user_sentiment)}"
            
        # Xử lý câu hỏi so sánh và đề xuất
        if any(keyword in input_lower for keyword in ["so sánh", "khác biệt", "nên chọn", "tư vấn mua", "lời khuyên", "bảo quản", "sử dụng"]):
            comparison_info = get_comparison_and_recommendations(input_lower)
            if comparison_info:
                return f"{greeting}{comparison_info}"
            
        # Thêm điều kiện kiểm tra category
        if any(keyword in input_lower for keyword in ["danh mục", "loại", "nhóm"]):
            category_products = get_products_by_category(input_lower)
            if category_products:
                return f"{greeting}{category_products}"
        
        # Câu hỏi về công dụng sản phẩm
        if any(keyword in input_lower for keyword in ["công dụng", "tác dụng", "để làm gì", "dùng để"]):
            product_info = get_product_info(input_lower)
            if product_info:
                return product_info
            return f"{greeting}{get_openai_response(user_input)}"
            
        # Câu hỏi về giá và khuyến mãi
        if any(keyword in input_lower for keyword in ["giá", "khuyến mãi", "giảm giá", "combo"]):
            product_info = get_product_info(input_lower)
            if product_info:
                return product_info
            return f"{greeting}Hiện tại shop đang có chương trình mua 3 tặng 1 với một số sản phẩm gốm sứ! Bạn có muốn mình giới thiệu cụ thể không?"
        
        # Tìm kiếm sản phẩm nâng cao (loại trừ câu hỏi về địa điểm mua)
        if any(keyword in input_lower for keyword in ["tìm sản phẩm", "gợi ý sản phẩm", "muốn mua sản phẩm", "cần sản phẩm", "tìm kiếm"]) and not any(keyword in input_lower for keyword in ["mua ở đâu", "ở đâu", "địa điểm", "cửa hàng"]):
            products = search_products(user_input, limit=5)
            if products:
                intro = random.choice([
                    "🔍 Mình tìm thấy một số sản phẩm thủ công phù hợp với yêu cầu của bạn:",
                    "✨ Đây là những sản phẩm làng nghề mà mình nghĩ bạn sẽ thích:",
                    "🛍️ Shop có những sản phẩm thủ công sau đây phù hợp với nhu cầu của bạn:",
                ])

                product_list = ""
                for i, p in enumerate(products, 1):
                    rating_text = f"⭐ {p['rating']:.1f} ({p['reviews']} đánh giá)" if p['rating'] > 0 else "⭐ Chưa có đánh giá"
                    stock_status = "✅ Còn hàng" if p['stock'] > 0 else "❌ Hết hàng"

                    product_list += f"""
**{i}. {p['name']}** 🏺
💰 **Giá:** {p['price']:,.0f} VND
{rating_text}
🏪 **Làng nghề:** {p['village_name'] or 'Đang cập nhật'}
📂 **Danh mục:** {p['category'] or 'Thủ công mỹ nghệ'}
📦 **Tình trạng:** {stock_status} ({p['stock']} sản phẩm)
📝 **Mô tả:** {p['description'][:100]}...

"""

                return f"{greeting}{intro}\n{product_list}\n💬 Bạn có muốn xem chi tiết sản phẩm nào không? {get_response_ending()}"
        
        # Phản hồi cá nhân hóa
        if "chào" in input_lower or "hello" in input_lower or "hi" in input_lower:
            return f"Chào bạn! 👋 Mình là trợ lý của làng nghề truyền thống Đà Nẵng. Mình có thể giúp gì cho bạn hôm nay?"
        
        # Xử lý câu hỏi về giao hàng và vận chuyển
        if any(keyword in input_lower for keyword in ["giao hàng", "vận chuyển", "ship", "thời gian", "phí", "thanh toán", "đổi trả"]):
            shipping_info = get_shipping_info(input_lower)
            if shipping_info:
                return f"{greeting}{shipping_info}"
        
        # Xử lý câu hỏi về tài khoản admin
        if any(keyword in input_lower for keyword in ["admin", "tài khoản", "account", "password", "mật khẩu", "đăng nhập", "login"]):
            return f"{greeting}Xin lỗi, mình là chatbot chuyên về làng nghề truyền thống Đà Nẵng. Mình không thể cung cấp thông tin về tài khoản admin. Bạn có muốn tìm hiểu về các làng nghề Đà Nẵng nổi tiếng không?"
        
        # Xử lý câu hỏi toán học và các câu hỏi khác
        if any(keyword in input_lower for keyword in ["tính toán", "làm toán", "cộng", "trừ", "nhân", "chia", "tính"]):
            return f"{greeting}Xin lỗi, mình là chatbot chuyên về làng nghề truyền thống Đà Nẵng và sản phẩm thủ công mỹ nghệ. Mình không thể làm toán, nhưng mình có thể giúp bạn tìm hiểu về các làng nghề Đà Nẵng, sản phẩm thủ công, và tư vấn mua sắm. Bạn có muốn hỏi về những chủ đề này không?"
        


        # Sử dụng OpenAI với context-aware cho các câu hỏi khác (không trùng với các điều kiện trên)
        context_type = "general"
        if any(keyword in input_lower for keyword in ["sản phẩm", "mua", "giá", "chất lượng"]) and not any(keyword in input_lower for keyword in ["mua ở đâu", "địa điểm mua"]):
            context_type = "product"
        elif any(keyword in input_lower for keyword in ["lịch sử", "văn hóa", "truyền thống"]) and not any(keyword in input_lower for keyword in ["làng nghề"]):
            context_type = "village"

        # Thử OpenAI trước, nếu lỗi thì dùng fallback
        ai_response = get_openai_response(user_input, context_type)
        if "không thể kết nối với AI" in ai_response or "hệ thống AI" in ai_response:
            ai_response = get_fallback_response(user_input, context_type)

        return f"{greeting}{ai_response}"
        
    except Exception as e:
        return f"Xin lỗi bạn! 🙇‍♂️ Mình đang gặp chút vấn đề kỹ thuật: {str(e)}. Bạn có thể thử lại sau hoặc liên hệ với shop qua hotline 1900xxxx nhé!"

# Route cho trang chính
@app.route('/')
def index():
    return render_template('index.html')

# Route xử lý tin nhắn từ người dùng với rate limiting
@app.route('/chat', methods=['POST'])
def chat():
    try:
        # Lấy client IP để rate limiting
        client_ip = request.environ.get('HTTP_X_FORWARDED_FOR', request.environ.get('REMOTE_ADDR', 'unknown'))

        # Kiểm tra rate limit
        if not api_rate_limiter.is_allowed(client_ip):
            return jsonify({
                'error': 'Rate limit exceeded',
                'message': 'Bạn đã gửi quá nhiều tin nhắn. Vui lòng thử lại sau 1 phút.'
            }), 429

        # Validate input
        if not request.json or 'message' not in request.json:
            return jsonify({
                'error': 'Invalid request',
                'message': 'Vui lòng gửi tin nhắn hợp lệ.'
            }), 400

        user_input = request.json.get('message', '').strip()

        # Kiểm tra độ dài tin nhắn
        if len(user_input) > 500:
            return jsonify({
                'error': 'Message too long',
                'message': 'Tin nhắn quá dài. Vui lòng gửi tin nhắn ngắn hơn 500 ký tự.'
            }), 400

        if not user_input:
            return jsonify({
                'error': 'Empty message',
                'message': 'Vui lòng nhập tin nhắn.'
            }), 400

        # Xử lý tin nhắn
        response = chatbot_response(user_input)

        return jsonify({
            'response': response,
            'status': 'success'
        })

    except Exception as e:
        print(f"Lỗi trong chat endpoint: {str(e)}")
        return jsonify({
            'error': 'Internal server error',
            'message': 'Xin lỗi, có lỗi xảy ra. Vui lòng thử lại sau.'
        }), 500

# Chạy ứng dụng
if __name__ == "__main__":
    try:
        # Kiểm tra kết nối database trước khi chạy
        conn = connect_db()
        print("✅ Kết nối database thành công!")
        conn.close()
        
        # Kiểm tra API key OpenAI
        try:
            if openai.api_key and openai.api_key != "your-openai-api-key-here":
                from openai import OpenAI
                client = OpenAI(api_key=openai.api_key)
                test_response = client.chat.completions.create(
                    model="gpt-3.5-turbo",
                    messages=[{"role": "user", "content": "Test"}],
                    max_tokens=10,
                    timeout=10
                )
                print("✅ Kết nối OpenAI API thành công!")
            else:
                print("⚠️ OpenAI API key chưa được cấu hình trong file .env")
                print("💡 Chatbot sẽ sử dụng phản hồi cơ bản thay vì AI")
        except Exception as e:
            print(f"⚠️ Cảnh báo OpenAI API: {str(e)}")
            print("💡 Chatbot vẫn hoạt động với database và phản hồi cơ bản")
            print("🔧 Kiểm tra API key trong file .env hoặc kết nối internet")
        
        print("🚀 Chatbot Làng Nghề Đà Nẵng đã sẵn sàng!")
        print("📍 Truy cập: http://localhost:5000")
        print("💡 Tính năng:")
        print("   - Tìm kiếm sản phẩm thủ công")
        print("   - Thông tin làng nghề Đà Nẵng từ internet + database")
        print("   - Tư vấn và so sánh sản phẩm")
        print("   - Hỗ trợ đa dạng câu hỏi về Đà Nẵng")
        
    except Exception as e:
        print(f"❌ Lỗi khởi động: {e}")
        print("💡 Kiểm tra:")
        print("   - Kết nối database SQL Server")
        print("   - API key OpenAI")
        print("   - Cài đặt thư viện pyodbc, openai, flask")
    
    app.run(debug=True, host='localhost', port=5000)