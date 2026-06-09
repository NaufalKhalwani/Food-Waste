package handlers

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

// JWTAuthMiddleware memvalidasi token JWT dari header Authorization dan mengecek hak akses role
func JWTAuthMiddleware(allowedRoles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Header otorisasi (Authorization) diperlukan"})
			c.Abort()
			return
		}

		// Mendukung format "Bearer <token>"
		parts := strings.Split(authHeader, " ")
		var tokenStr string
		if len(parts) == 2 && parts[0] == "Bearer" {
			tokenStr = parts[1]
		} else {
			tokenStr = parts[0]
		}

		claims, err := ValidateJWT(tokenStr)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token tidak valid atau kadaluarsa: " + err.Error()})
			c.Abort()
			return
		}

		// Simpan informasi pengguna ke dalam Gin context
		c.Set("userId", claims.ID)
		c.Set("email", claims.Email)
		c.Set("role", claims.Role)
		c.Set("subRole", claims.SubRole)

		// Jika ada batasan role, periksa apakah role atau subRole pengguna diperbolehkan
		if len(allowedRoles) > 0 {
			authorized := false
			for _, allowedRole := range allowedRoles {
				if claims.Role == allowedRole || claims.SubRole == allowedRole {
					authorized = true
					break
				}
			}

			if !authorized {
				c.JSON(http.StatusForbidden, gin.H{"error": "Anda tidak memiliki akses ke resource ini"})
				c.Abort()
				return
			}
		}

		c.Next()
	}
}
