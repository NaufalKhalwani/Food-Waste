# Panduan Penggunaan Backend - Anti Food Waste API

Backend ini dibangun menggunakan **Go** dengan framework **Gin** dan ORM **GORM**. Aplikasi ini kini mendukung pembatasan hak akses berbasis peran (Role-based Access Control), Otentikasi JWT (JSON Web Token), Enkripsi Password (`bcrypt`), serta pembaruan dan penyaringan otomatis makanan yang kadaluarsa.

---

## 1. Setup & Konfigurasi

### Prasyarat
- **Go** (versi 1.22 atau lebih tinggi)
- **PostgreSQL** database

### Langkah Setup
1. Masuk ke folder backend:
   ```bash
   cd backend
   ```
2. Pastikan file `.env` diisi dengan benar. Sesuaikan kredensial database PostgreSQL Anda serta tentukan `JWT_SECRET`:
   ```env
   APP_ENV = development
   APP_PORT = 8080

   DB_PORT = 5432
   DB_HOST = localhost
   DB_NAME = anti_food_waste
   DB_USER = <username_db>
   DB_PASSWORD = <password_db>
   JWT_SECRET = supersecretkeyforantifoodwasteapp2026
   ```
3. Unduh seluruh dependensi yang diperlukan:
   ```bash
   go mod tidy
   ```
4. Jalankan aplikasi backend:
   ```bash
   go run main.go
   ```
   Server akan berjalan secara default di `http://localhost:8080`.

---

## 2. Pengujian (Testing)

Anda dapat memverifikasi modul otentikasi JWT, middleware, dan FSM status dengan menjalankan unit test berikut:

- **Menjalankan test di internal package backend (JWT & Middleware)**:
  ```bash
  go test ./int/handlers/...
  ```
- **Menjalankan unit test model independen**:
  ```bash
  go test ./test/...
  ```

---

## 3. Alur Penggunaan API & Autentikasi JWT

### A. Registrasi Pengguna
Buat akun baru menggunakan metode `POST`. Password akan otomatis di-hash secara aman menggunakan `bcrypt` sebelum disimpan ke database.

* **Registrasi Pendonor**
  * `POST /api/Register/pendonor`
  * Body (JSON):
    ```json
    {
      "nama_pendonor": "Budi Donor",
      "email_pendonor": "budi@mail.com",
      "password": "password123",
      "alamat_pendonor": "Bandung"
    }
    ```

* **Registrasi Penerima**
  * `POST /api/Register/penerima`
  * Body (JSON):
    ```json
    {
      "nama_penerima": "Ani Penerima",
      "email": "ani@mail.com",
      "password": "password123",
      "alamat": "Jakarta",
      "nomor_telfon": "081234567890"
    }
    ```

* **Registrasi Admin**
  * `POST /api/Register/admin`
  * Body (JSON):
    ```json
    {
      "NamaAdmin": "AdminSatu",
      "email_admin": "admin@mail.com",
      "password": "adminpassword"
    }
    ```

---

### B. Login & Mendapatkan Token JWT
Lakukan `POST` request untuk menukar kredensial email & password dengan token JWT yang memuat informasi Role dan Sub-Role.

* **Login (Contoh Pendonor)**
  * `POST /api/Login/pendonor` (juga tersedia `/api/Login/penerima` dan `/api/Login/admin`)
  * Body (JSON):
    ```json
    {
      "email": "budi@mail.com",
      "password": "password123"
    }
    ```
  * Response (JSON):
    ```json
    {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "user": {
        "id": "DNR-1717772800",
        "nama": "Budi Donor",
        "email": "budi@mail.com",
        "role": "user",
        "sub_role": "pendonor"
      }
    }
    ```

---

### C. Mengakses Endpoint Terproteksi
Untuk mengakses endpoint terproteksi, Anda wajib melampirkan JWT token pada HTTP Request Header:
```http
Authorization: Bearer <JWT_TOKEN>
```

#### Aturan Otorisasi Berdasarkan Role:
| Endpoint | HTTP Method | Hak Akses Role / Sub-Role | Keterangan |
| :--- | :---: | :--- | :--- |
| `/api/makanan` | `POST` | `pendonor` | Mendaftarkan makanan baru |
| `/api/makanan` | `GET` | `admin`, `user` (`pendonor`/`penerima`) | Mengambil daftar makanan yang tersedia |
| `/api/makanan/:id` | `PUT`, `DELETE` | `admin`, `pendonor` | Memperbarui/menghapus makanan |
| `/api/request` | `POST` | `penerima` | Membuat permohonan makanan |
| `/api/request` | `GET` | `admin`, `penerima` | Mengambil data riwayat permohonan |
| `/api/penyimpanan` | `POST`, `PUT`, `DELETE` | `admin` | Mengelola data tempat penyimpanan makanan |
| `/api/penyimpanan` | `GET` | `admin`, `user` | Melihat info tempat penyimpanan |

---

### D. Contoh & Alur Langkah Penggunaan (Penyimpanan, Makanan, Request)

> [!NOTE]
> **Otomatisasi ID dari Token JWT**:
> Anda tidak perlu mengirimkan field `id_admin`, `id_donor`, atau `penerimaid_penerima` di dalam request body. Backend akan secara otomatis mendeteksi dan memasukkan ID pengguna/admin yang relevan berdasarkan klaim token JWT yang terlampir di header request.

Berikut adalah urutan langkah pemanggilan API untuk mensimulasikan alur kerja sistem:

#### Langkah 1: Membuat Tempat Penyimpanan (Oleh Admin)
Admin mendaftarkan lokasi penyimpanan fisik untuk makanan yang didonorkan. ID Admin akan diambil otomatis dari JWT token.
* **Endpoint**: `POST /api/penyimpanan`
* **Header**: `Authorization: Bearer <TOKEN_ADMIN>`
* **Body (JSON)**:
  ```json
  {
    "nama_tempat": "Gudang Pangan Bandung",
    "alamat": "Jl. Merdeka No. 45, Bandung",
    "kapasitas": 100
  }
  ```
* **Keterangan**: Catat nilai `"penyimpanan_id"` dari response (misal: `"PSN-1717773000"`) untuk digunakan pada pendaftaran makanan.

---

#### Langkah 2: Mendaftarkan Makanan (Oleh Pendonor)
Pendonor mendonasikan makanan dan meletakkannya di penyimpanan tertentu. ID Donor akan diambil otomatis dari JWT token.
* **Endpoint**: `POST /api/makanan`
* **Header**: `Authorization: Bearer <TOKEN_PENDONOR>`
* **Body (JSON)**:
  ```json
  {
    "penyimpanan_id": "PSN-1717773000",
    "jumlah": 20,
    "kondisi_makanan": "Sangat Baik",
    "status_makanan": "tersedia",
    "tanggal_kadaluarsa": "2026-06-20T00:00:00Z"
  }
  ```
* **Keterangan**: Catat nilai `"makanan_id"` dari response (misal: `"MKN-1717774000"`) untuk digunakan saat penerima mengajukan permohonan.

---

#### Langkah 3: Mengajukan Permohonan Makanan (Oleh Penerima)
Penerima mengajukan permohonan untuk mengambil makanan yang terdaftar. ID Penerima akan diambil otomatis dari JWT token.
* **Endpoint**: `POST /api/request`
* **Header**: `Authorization: Bearer <TOKEN_PENERIMA>`
* **Body (JSON)**:
  ```json
  {
    "id_admin": "ADM-1717772800",
    "makanan_id": "MKN-1717774000",
    "status": "pending"
  }
  ```

---

## 4. Mekanisme Penyaringan Makanan Kadaluarsa (Automatic Filter)

Sistem ini memiliki filtrasi otomatis terintegrasi ketika daftar makanan diambil:
1. Saat memanggil **`GET /api/makanan`**, sistem membandingkan `tanggal_kadaluarsa` setiap makanan dengan waktu server saat ini (`time.Now()`).
2. Jika suatu makanan telah melewati tanggal kadaluarsa:
   - Status makanan di database akan diperbarui menjadi `"kadaluarsa"`.
3. Response JSON yang dikembalikan hanya berisi makanan dengan status `"tersedia"` (makanan segar yang belum kadaluarsa), sehingga secara otomatis memfilter makanan yang sudah tidak layak dikonsumsi.
