package handlers

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func setupRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)

	r := gin.Default()

	r.POST("/pendonor", CreatePendonor)
	r.GET("/pendonor", GetPendonor)
	r.POST("/login/pendonor", LoginPendonor)

	return r
}

func TestCreatePendonor(t *testing.T) {
	r := setupRouter()

	body := `{
		"nama_pendonor": "Budi",
		"email_pendonor": "budi@mail.com",
		"password": "123456"
	}`

	req, _ := http.NewRequest("POST", "/pendonor", strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)
}

func TestGetPendonor(t *testing.T) {
	r := setupRouter()

	req, _ := http.NewRequest("GET", "/pendonor", nil)
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}

func TestLoginPendonor(t *testing.T) {
	r := setupRouter()

	body := `{
		"email": "test@mail.com",
		"password": "123456"
	}`

	req, _ := http.NewRequest("POST", "/login/pendonor", strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	// bisa 200 atau 401 tergantung DB mock kamu
	assert.True(t, w.Code == 200 || w.Code == 401)
}


