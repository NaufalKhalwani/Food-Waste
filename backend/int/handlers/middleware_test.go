package handlers

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"anti-food-waste2.0/int/config"
	"github.com/gin-gonic/gin"
)

func TestJWTAuthMiddleware(t *testing.T) {
	// Setup gin in test mode
	gin.SetMode(gin.TestMode)
	config.AppConfig.JWTSecret = "testsecretkeyforantifoodwasteapp"

	// Create test token
	validToken, err := GenerateJWT("USR-1", "user@example.com", "user", "pendonor")
	if err != nil {
		t.Fatalf("GenerateJWT failed: %v", err)
	}

	tests := []struct {
		name           string
		authHeader     string
		allowedRoles   []string
		expectedStatus int
	}{
		{
			name:           "Valid Token, No Role Restriction",
			authHeader:     "Bearer " + validToken,
			allowedRoles:   nil,
			expectedStatus: http.StatusOK,
		},
		{
			name:           "Valid Token, Allowed Role 'user'",
			authHeader:     "Bearer " + validToken,
			allowedRoles:   []string{"user"},
			expectedStatus: http.StatusOK,
		},
		{
			name:           "Valid Token, Allowed Sub-role 'pendonor'",
			authHeader:     "Bearer " + validToken,
			allowedRoles:   []string{"pendonor"},
			expectedStatus: http.StatusOK,
		},
		{
			name:           "Valid Token, Disallowed Role 'admin'",
			authHeader:     "Bearer " + validToken,
			allowedRoles:   []string{"admin"},
			expectedStatus: http.StatusForbidden,
		},
		{
			name:           "Missing Authorization Header",
			authHeader:     "",
			allowedRoles:   nil,
			expectedStatus: http.StatusUnauthorized,
		},
		{
			name:           "Invalid Token Signature",
			authHeader:     "Bearer invalid.token.payload",
			allowedRoles:   nil,
			expectedStatus: http.StatusUnauthorized,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Setup test router
			r := gin.New()
			r.Use(JWTAuthMiddleware(tt.allowedRoles...))
			r.GET("/test", func(c *gin.Context) {
				c.Status(http.StatusOK)
			})

			req, _ := http.NewRequest("GET", "/test", nil)
			if tt.authHeader != "" {
				req.Header.Set("Authorization", tt.authHeader)
			}

			w := httptest.NewRecorder()
			r.ServeHTTP(w, req)

			if w.Code != tt.expectedStatus {
				t.Errorf("Expected status code %d, got %d", tt.expectedStatus, w.Code)
			}
		})
	}
}
