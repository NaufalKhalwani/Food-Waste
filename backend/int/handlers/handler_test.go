package handlers

import (
	"net/http"
	"net/http/httptest"
	"os"
	"strings"
	"testing"

	"anti-food-waste2.0/int/config"
	"anti-food-waste2.0/int/db"
	"anti-food-waste2.0/int/model"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

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

func TestCreatePendonor(t *testing.T) {
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

func TestGetPendonor(t *testing.T) {
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

func TestLoginPendonor(t *testing.T) {
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
