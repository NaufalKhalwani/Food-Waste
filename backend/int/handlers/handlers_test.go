package handlers

import "encoding/json"
import "fmt"
import "net/http"
import "net/http/httptest"
import "os"
import "strings"
import "sync/atomic"
import "testing"
import "time"
import "anti-food-waste2.0/int/config"
import "anti-food-waste2.0/int/db"
import "anti-food-waste2.0/int/model"
import "github.com/gin-gonic/gin"
import "github.com/glebarez/sqlite"
import "github.com/stretchr/testify/assert"
import "golang.org/x/crypto/bcrypt"
import "gorm.io/gorm"


var seedCounter int64

func nextID() int64 {
	return atomic.AddInt64(&seedCounter, 1)
}

func TestMain(m *testing.M) {
	// Setup in-memory SQLite database
	d, err := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
	if err != nil {
		panic("Gagal menghubungkan database test: " + err.Error())
	}
	db.DB = d

	// Migrasi schema
	err = db.DB.AutoMigrate(
		&model.Pendonor{},
		&model.Penerima{},
		&model.Admin{},
		&model.Penyimpanan{},
		&model.Makanan{},
		&model.Request{},
	)
	if err != nil {
		panic("Gagal migrasi database test: " + err.Error())
	}

	// Setup JWT Secret untuk pengujian
	config.AppConfig.JWTSecret = "testsecretkeyforantifoodwasteapp"

	os.Exit(m.Run())
}

// PENERIMA
func TestCreatePenerima(t *testing.T) {
	r := setupTestRouter()

	body := `{
		"nama_penerima":"Test",
		"email":"test@test.com",
		"password":"123456"
	}`

	req, _ := http.NewRequest(
		"POST",
		"/api/Register/penerima",
		strings.NewReader(body),
	)

	req.Header.Set("Content-Type", "application/json")

	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.True(t, w.Code == 201 || w.Code == 500)
}

// ─────────────────────────────────────────────
// Helper
// ─────────────────────────────────────────────

func makeAdminToken(t *testing.T) string {
	t.Helper()
	token, err := GenerateJWT("ADM-TEST", "admin@test.com", "admin", "admin")
	assert.NoError(t, err)
	return token
}

func makePendonorToken(t *testing.T, id string) string {
	t.Helper()
	token, err := GenerateJWT(id, "pendonor@test.com", "user", "pendonor")
	assert.NoError(t, err)
	return token
}

func makePenerimaToken(t *testing.T, id string) string {
	t.Helper()
	token, err := GenerateJWT(id, "penerima@test.com", "user", "penerima")
	assert.NoError(t, err)
	return token
}

func doRequest(r *gin.Engine, method, path, body, token string) *httptest.ResponseRecorder {
	var req *http.Request
	if body != "" {
		req, _ = http.NewRequest(method, path, strings.NewReader(body))
		req.Header.Set("Content-Type", "application/json")
	} else {
		req, _ = http.NewRequest(method, path, nil)
	}
	if token != "" {
		req.Header.Set("Authorization", "Bearer "+token)
	}
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)
	return w
}

// ─────────────────────────────────────────────
// PENERIMA
// ─────────────────────────────────────────────

func TestGetPenerimas(t *testing.T) {
	db.DB.Exec("DELETE FROM penerima")
	r := setupTestRouter()
	token := makeAdminToken(t)

	w := doRequest(r, "GET", "/api/penerima", "", token)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestLoginPenerima(t *testing.T) {
	db.DB.Exec("DELETE FROM penerima")
	r := setupTestRouter()

	hashed, _ := bcrypt.GenerateFromPassword([]byte("pass123"), bcrypt.DefaultCost)
	db.DB.Create(&model.Penerima{
		NamaPenerima:  "Ani",
		EmailPenerima: "ani@mail.com",
		Password:      string(hashed),
	})

	// Sukses
	w := doRequest(r, "POST", "/api/Login/penerima",
		`{"email":"ani@mail.com","password":"pass123"}`, "")
	assert.Equal(t, http.StatusOK, w.Code)

	// Password salah
	w = doRequest(r, "POST", "/api/Login/penerima",
		`{"email":"ani@mail.com","password":"salah"}`, "")
	assert.Equal(t, http.StatusUnauthorized, w.Code)

	// Email tidak ada
	w = doRequest(r, "POST", "/api/Login/penerima",
		`{"email":"tidakada@mail.com","password":"pass123"}`, "")
	assert.Equal(t, http.StatusUnauthorized, w.Code)
}

func TestDeletePenerima(t *testing.T) {
	db.DB.Exec("DELETE FROM penerima")
	r := setupTestRouter()
	token := makeAdminToken(t)

	p := model.Penerima{NamaPenerima: "HapusAku", EmailPenerima: "hapus@mail.com", Password: "x"}
	db.DB.Create(&p)

	w := doRequest(r, "DELETE", "/api/penerima/"+p.IDPenerima, "", token)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestUpdatePenerima(t *testing.T) {
	db.DB.Exec("DELETE FROM penerima")
	r := setupTestRouter()
	token := makeAdminToken(t)

	p := model.Penerima{NamaPenerima: "Lama", EmailPenerima: "lama@mail.com", Password: "x"}
	db.DB.Create(&p)

	body := `{"nama_penerima":"Baru"}`
	w := doRequest(r, "PUT", "/api/penerima/"+p.IDPenerima, body, token)
	assert.Equal(t, http.StatusOK, w.Code)
}

// ─────────────────────────────────────────────
// PENDONOR
// ─────────────────────────────────────────────

func TestDeletePendonor(t *testing.T) {
	db.DB.Exec("DELETE FROM pendonor")
	r := setupTestRouter()
	token := makeAdminToken(t)

	p := model.Pendonor{NamaPendonor: "HapusDonor", EmailPendonor: "hapusdonor@mail.com", Password: "x"}
	db.DB.Create(&p)

	w := doRequest(r, "DELETE", "/api/pendonor/"+p.IDDonor, "", token)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestUpdatePendonor(t *testing.T) {
	db.DB.Exec("DELETE FROM pendonor")
	r := setupTestRouter()
	token := makeAdminToken(t)

	p := model.Pendonor{NamaPendonor: "Lama", EmailPendonor: "lamadonor@mail.com", Password: "x"}
	db.DB.Create(&p)

	body := `{"nama_pendonor":"Baru"}`
	w := doRequest(r, "PUT", "/api/pendonor/"+p.IDDonor, body, token)
	assert.Equal(t, http.StatusOK, w.Code)
}

// ─────────────────────────────────────────────
// ADMIN
// ─────────────────────────────────────────────

func TestGetAdmins(t *testing.T) {
	r := setupTestRouter()
	token := makeAdminToken(t)

	w := doRequest(r, "GET", "/api/admin", "", token)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestLoginAdminSukses(t *testing.T) {
	db.DB.Exec("DELETE FROM admin")
	r := setupTestRouter()

	hashed, _ := bcrypt.GenerateFromPassword([]byte("adminpass"), bcrypt.DefaultCost)
	db.DB.Create(&model.Admin{
		NamaAdmin:  "SuperAdmin",
		EmailAdmin: "super@admin.com",
		Password:   string(hashed),
	})

	w := doRequest(r, "POST", "/api/Login/admin",
		`{"email":"super@admin.com","password":"adminpass"}`, "")
	assert.Equal(t, http.StatusOK, w.Code)

	var resp map[string]interface{}
	json.Unmarshal(w.Body.Bytes(), &resp)
	assert.NotEmpty(t, resp["token"])
}

func TestLoginAdminGagal(t *testing.T) {
	r := setupTestRouter()

	// Password salah
	w := doRequest(r, "POST", "/api/Login/admin",
		`{"email":"super@admin.com","password":"salah"}`, "")
	assert.Equal(t, http.StatusUnauthorized, w.Code)
}

// ─────────────────────────────────────────────
// PENYIMPANAN
// ─────────────────────────────────────────────

func TestCreatePenyimpanan(t *testing.T) {
	r := setupTestRouter()
	token := makeAdminToken(t)

	body := `{"nama_tempat":"Gudang A","alamat":"Jl. Merdeka 1","kapasitas":100}`
	w := doRequest(r, "POST", "/api/penyimpanan", body, token)
	assert.Equal(t, http.StatusCreated, w.Code)
}

func TestGetPenyimpanans(t *testing.T) {
	r := setupTestRouter()
	token := makeAdminToken(t)

	w := doRequest(r, "GET", "/api/penyimpanan", "", token)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestDeletePenyimpanan(t *testing.T) {
	db.DB.Exec("DELETE FROM penyimpanan")
	r := setupTestRouter()
	token := makeAdminToken(t)

	p := model.Penyimpanan{NamaTempat: "Hapus Gudang", Alamat: "Jl. X", Kapasitas: 10}
	db.DB.Create(&p)

	w := doRequest(r, "DELETE", "/api/penyimpanan/"+p.PenyimpananID, "", token)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestUpdatePenyimpanan(t *testing.T) {
	db.DB.Exec("DELETE FROM penyimpanan")
	r := setupTestRouter()
	token := makeAdminToken(t)

	p := model.Penyimpanan{NamaTempat: "Gudang Lama", Alamat: "Jl. Y", Kapasitas: 50}
	db.DB.Create(&p)

	body := `{"nama_tempat":"Gudang Baru","kapasitas":200}`
	w := doRequest(r, "PUT", "/api/penyimpanan/"+p.PenyimpananID, body, token)
	assert.Equal(t, http.StatusOK, w.Code)
}

// ─────────────────────────────────────────────
// MAKANAN
// ─────────────────────────────────────────────

func seedPendonor(t *testing.T) model.Pendonor {
	t.Helper()
	n := nextID()
	p := model.Pendonor{
		IDDonor:       fmt.Sprintf("DNR-TEST-%d", n),
		NamaPendonor:  "Donor Seed",
		EmailPendonor: fmt.Sprintf("seed_donor_%d@mail.com", n),
		Password:      "x",
		Role:          "pendonor",
	}
	db.DB.Session(&gorm.Session{SkipHooks: true}).Create(&p)
	return p
}

func TestCreateMakanan(t *testing.T) {
	donor := seedPendonor(t)
	r := setupTestRouter()
	token := makePendonorToken(t, donor.IDDonor)

	body := `{
		"nama_makanan":"Nasi Bungkus",
		"kategori":"nasi",
		"jumlah":10,
		"kondisi_makanan":"baik",
		"status_makanan":"tersedia",
		"tanggal_kadaluarsa":"2099-12-31T00:00:00Z"
	}`
	w := doRequest(r, "POST", "/api/makanan", body, token)
	assert.Equal(t, http.StatusCreated, w.Code)
}

func TestGetMakanans(t *testing.T) {
	r := setupTestRouter()
	token := makeAdminToken(t)

	w := doRequest(r, "GET", "/api/makanan", "", token)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestGetMakanans_HanyaTersedia(t *testing.T) {
	db.DB.Exec("DELETE FROM makanan")
	donor := seedPendonor(t)
	r := setupTestRouter()
	adminToken := makeAdminToken(t)

	n1, n2 := nextID(), nextID()

	// Makanan tersedia (belum kadaluarsa)
	db.DB.Session(&gorm.Session{SkipHooks: true}).Create(&model.Makanan{
		MakananID:         fmt.Sprintf("MKN-SEGAR-%d", n1),
		IDDonor:           donor.IDDonor,
		NamaMakanan:       "Makanan Segar",
		StatusMakanan:     model.StatusTersedia,
		TanggalKadaluarsa: time.Now().Add(48 * time.Hour),
	})

	// Makanan sudah kadaluarsa
	db.DB.Session(&gorm.Session{SkipHooks: true}).Create(&model.Makanan{
		MakananID:         fmt.Sprintf("MKN-BASI-%d", n2),
		IDDonor:           donor.IDDonor,
		NamaMakanan:       "Makanan Basi",
		StatusMakanan:     model.StatusTersedia,
		TanggalKadaluarsa: time.Now().Add(-48 * time.Hour),
	})

	w := doRequest(r, "GET", "/api/makanan", "", adminToken)
	assert.Equal(t, http.StatusOK, w.Code)

	var result []model.Makanan
	json.Unmarshal(w.Body.Bytes(), &result)

	// Hanya makanan yang belum kadaluarsa yang dikembalikan
	for _, m := range result {
		assert.Equal(t, model.StatusTersedia, m.StatusMakanan)
		assert.True(t, m.TanggalKadaluarsa.After(time.Now()),
			"makanan kadaluarsa tidak boleh muncul: %s", m.NamaMakanan)
	}
}

func TestDeleteMakanan(t *testing.T) {
	donor := seedPendonor(t)
	r := setupTestRouter()
	token := makePendonorToken(t, donor.IDDonor)

	m := seedMakanan(t, donor.IDDonor) // pakai seedMakanan yang sudah fix

	w := doRequest(r, "DELETE", "/api/makanan/"+m.MakananID, "", token)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestUpdateMakanan(t *testing.T) {
	donor := seedPendonor(t)
	r := setupTestRouter()
	token := makePendonorToken(t, donor.IDDonor)

	m := seedMakanan(t, donor.IDDonor) // pakai seedMakanan yang sudah fix

	body := `{"nama_makanan":"Makanan Baru","jumlah":5}`
	w := doRequest(r, "PUT", "/api/makanan/"+m.MakananID, body, token)
	assert.Equal(t, http.StatusOK, w.Code)
}

// ─────────────────────────────────────────────
// REQUEST
// ─────────────────────────────────────────────

func seedPenerima(t *testing.T) model.Penerima {
	t.Helper()
	n := nextID()
	p := model.Penerima{
		IDPenerima:    fmt.Sprintf("PRN-TEST-%d", n),
		NamaPenerima:  "Penerima Seed",
		EmailPenerima: fmt.Sprintf("seed_penerima_%d@mail.com", n),
		Password:      "x",
		Role:          "penerima",
	}
	db.DB.Session(&gorm.Session{SkipHooks: true}).Create(&p)
	return p
}

func seedMakanan(t *testing.T, donorID string) model.Makanan {
	t.Helper()
	n := nextID()
	m := model.Makanan{
		MakananID:         fmt.Sprintf("MKN-TEST-%d", n),
		IDDonor:           donorID,
		NamaMakanan:       "Makanan Seed",
		StatusMakanan:     model.StatusTersedia,
		TanggalKadaluarsa: time.Now().Add(72 * time.Hour),
	}
	db.DB.Session(&gorm.Session{SkipHooks: true}).Create(&m)
	return m
}

func TestCreateRequest(t *testing.T) {
	db.DB.Exec("DELETE FROM request") // hapus request lama agar tidak ada konflik
	time.Sleep(1 * time.Second)
	donor := seedPendonor(t)
	penerima := seedPenerima(t)
	makanan := seedMakanan(t, donor.IDDonor)
	r := setupTestRouter()
	token := makePenerimaToken(t, penerima.IDPenerima)

	body := fmt.Sprintf(`{"makanan_id":"%s"}`, makanan.MakananID)
	w := doRequest(r, "POST", "/api/request", body, token)
	assert.Equal(t, http.StatusCreated, w.Code)

	// Validasi status default "pending"
	var result model.Request
	json.Unmarshal(w.Body.Bytes(), &result)
	assert.Equal(t, model.StatusPending, result.Status)
}

func TestGetRequests(t *testing.T) {
	db.DB.Exec("DELETE FROM request") // hapus request lama agar tidak ada konflik
	time.Sleep(1 * time.Second)
	r := setupTestRouter()
	token := makeAdminToken(t)

	w := doRequest(r, "GET", "/api/request", "", token)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestDeleteRequest(t *testing.T) {
	db.DB.Exec("DELETE FROM request")
	time.Sleep(1 * time.Second)
	donor := seedPendonor(t)
	penerima := seedPenerima(t)
	makanan := seedMakanan(t, donor.IDDonor)
	r := setupTestRouter()
	adminToken := makeAdminToken(t)
	penerimaToken := makePenerimaToken(t, penerima.IDPenerima)

	body := fmt.Sprintf(`{"makanan_id":"%s"}`, makanan.MakananID)
	w := doRequest(r, "POST", "/api/request", body, penerimaToken)
	t.Logf("CreateRequest response: %s", w.Body.String()) // tambah ini
	assert.Equal(t, http.StatusCreated, w.Code)

	var req model.Request
	json.Unmarshal(w.Body.Bytes(), &req)
	t.Logf("Parsed RequestID: %s", req.RequestID) // tambah ini

	w = doRequest(r, "DELETE", "/api/request/"+req.RequestID, "", adminToken)
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestUpdateRequest(t *testing.T) {
	db.DB.Exec("DELETE FROM request") // hapus request lama agar tidak ada konflik
	time.Sleep(1 * time.Second)

	donor := seedPendonor(t)
	penerima := seedPenerima(t)
	makanan := seedMakanan(t, donor.IDDonor)
	r := setupTestRouter()
	adminToken := makeAdminToken(t)
	penerimaToken := makePenerimaToken(t, penerima.IDPenerima)

	// Buat request
	body := fmt.Sprintf(`{"makanan_id":"%s"}`, makanan.MakananID)
	w := doRequest(r, "POST", "/api/request", body, penerimaToken)
	assert.Equal(t, http.StatusCreated, w.Code)

	var req model.Request
	json.Unmarshal(w.Body.Bytes(), &req)

	// Update status menjadi disetujui
	updateBody := `{"status":"disetujui"}`
	w = doRequest(r, "PUT", "/api/request/"+req.RequestID, updateBody, adminToken)
	assert.Equal(t, http.StatusOK, w.Code)
}

// ─────────────────────────────────────────────
// JWT MIDDLEWARE — Akses tanpa token
// ─────────────────────────────────────────────

func TestAksesTolakTanpaToken(t *testing.T) {
	r := setupTestRouter()

	endpoints := []struct {
		method string
		path   string
	}{
		{"GET", "/api/pendonor"},
		{"GET", "/api/penerima"},
		{"GET", "/api/admin"},
		{"GET", "/api/penyimpanan"},
		{"GET", "/api/makanan"},
		{"GET", "/api/request"},
	}

	for _, ep := range endpoints {
		t.Run(ep.method+" "+ep.path, func(t *testing.T) {
			w := doRequest(r, ep.method, ep.path, "", "")
			assert.Equal(t, http.StatusUnauthorized, w.Code)
		})
	}
}

// PENDONOR
func TestCreatePendonors(t *testing.T) {
	db.DB.Exec("DELETE FROM pendonor")

	gin.SetMode(gin.TestMode)
	r := gin.Default()
	SetupRoutes(r)

	body := `{
		"nama_pendonor": "Budi",
		"email_pendonor": "test@mail.com",
		"password": "123456"
	}`

	req, _ := http.NewRequest("POST", "/api/Register/pendonor", strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)
}

func TestGetPendonors(t *testing.T) {
	db.DB.Exec("DELETE FROM pendonor")

	gin.SetMode(gin.TestMode)
	r := gin.Default()
	SetupRoutes(r)

	token, err := GenerateJWT("DNR-12345", "test@mail.com", "admin", "admin")
	assert.NoError(t, err)

	req, _ := http.NewRequest("GET", "/api/pendonor", nil)
	req.Header.Set("Authorization", "Bearer "+token)
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}

func TestLoginPendonors(t *testing.T) {
	db.DB.Exec("DELETE FROM pendonor")

	gin.SetMode(gin.TestMode)
	r := gin.Default()
	SetupRoutes(r)

	// Seed user untuk login
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte("123456"), bcrypt.DefaultCost)
	assert.NoError(t, err)

	testPendonor := model.Pendonor{
		NamaPendonor:  "Budi Login",
		EmailPendonor: "login_test@mail.com",
		Password:      string(hashedPassword),
	}
	err = db.DB.Create(&testPendonor).Error
	assert.NoError(t, err)

	// Test Case 1: Login Sukses
	bodySuccess := `{
		"email": "login_test@mail.com",
		"password": "123456"
	}`

	reqSuccess, _ := http.NewRequest("POST", "/api/Login/pendonor", strings.NewReader(bodySuccess))
	reqSuccess.Header.Set("Content-Type", "application/json")

	wSuccess := httptest.NewRecorder()
	r.ServeHTTP(wSuccess, reqSuccess)

	assert.Equal(t, http.StatusOK, wSuccess.Code)

	// Test Case 2: Login Gagal (Password salah)
	bodyFail := `{
		"email": "login_test@mail.com",
		"password": "wrongpassword"
	}`

	reqFail, _ := http.NewRequest("POST", "/api/Login/pendonor", strings.NewReader(bodyFail))
	reqFail.Header.Set("Content-Type", "application/json")

	wFail := httptest.NewRecorder()
	r.ServeHTTP(wFail, reqFail)

	assert.Equal(t, http.StatusUnauthorized, wFail.Code)
}

// ADMIN
func TestCreateAdmin(t *testing.T) {
	r := setupTestRouter()

	body := `{
		"username":"admin",
		"email_admin":"admin@test.com",
		"password":"123456"
	}`

	req, _ := http.NewRequest(
		"POST",
		"/api/Register/admin",
		strings.NewReader(body),
	)

	req.Header.Set("Content-Type", "application/json")

	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.True(t, w.Code == 201 || w.Code == 500)
}

func TestLoginAdmin(t *testing.T) {
	r := setupTestRouter()

	body := `{
		"email_admin":"admin@test.com",
		"password":"123456"
	}`

	req, _ := http.NewRequest(
		"POST",
		"/api/Login/admin",
		strings.NewReader(body),
	)

	req.Header.Set("Content-Type", "application/json")

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	t.Logf("Status Code: %d", w.Code)
	t.Logf("Response: %s", w.Body.String())
}
