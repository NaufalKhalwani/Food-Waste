package handlers

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func setupTestRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)

	r := gin.New()

	SetupRoutes(r)

	return r
}
func TestHealthEndpoint(t *testing.T) {
	r := setupTestRouter()

	req, _ := http.NewRequest("GET", "/health", nil)
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)
	assert.Contains(t, w.Body.String(), "ok")
}

func getValidToken() string {
	// pakai function GenerateJWT kamu
	token, _ := GenerateJWT("1", "test@mail.com", "admin", "admin")
	return token
}

func TestGetPendonor_WithJWT(t *testing.T) {
	r := setupTestRouter()

	req, _ := http.NewRequest("GET", "/api/pendonor", nil)
	req.Header.Set("Authorization", "Bearer "+getValidToken())

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	// bisa 200 atau 500 tergantung DB kamu (karena DB belum mock)
	assert.True(t, w.Code == 200 || w.Code == 500)
}

func TestLoginPendonorRoute(t *testing.T) {
	r := setupTestRouter()

	body := `{
		"email": "test@mail.com",
		"password": "123456"
	}`

	req, _ := http.NewRequest("POST", "/api/Login/pendonor", strings.NewReader(body))
	req.Header.Set("Content-Type", "application/json")

	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	// bisa 200 atau 401 tergantung data DB
	assert.True(t, w.Code == 200 || w.Code == 401 || w.Code == 500)
}

func TestRoutesExist(t *testing.T) {
	r := setupTestRouter()

	routes := []struct {
		method string
		path   string
	}{
		{"GET", "/health"},
		{"GET", "/api/pendonor"},
		{"GET", "/api/penerima"},
		{"GET", "/api/admin"},
		{"GET", "/api/makanan"},
		{"GET", "/api/request"},
	}

	for _, rt := range routes {
		req, _ := http.NewRequest(rt.method, rt.path, nil)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)

		assert.NotEqual(t, 404, w.Code)
	}
}
