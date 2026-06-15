package handlers

import (
	"errors"
	"time"

	"anti-food-waste2.0/int/config"
	"github.com/golang-jwt/jwt/v5"
)

// JWTClaims mendefinisikan klaim kustom untuk JWT token kita
type JWTClaims struct {
	ID      string `json:"id"`
	Email   string `json:"email"`
	Role    string `json:"role"`     // "admin" atau "user"
	SubRole string `json:"sub_role"` // "admin", "pendonor", atau "penerima"
	jwt.RegisteredClaims
}

// GenerateJWT menghasilkan token JWT baru yang berlaku selama 24 jam
func GenerateJWT(id, email, role, subRole string) (string, error) {
	jwtSecret := []byte(config.AppConfig.JWTSecret)

	claims := JWTClaims{
		ID:      id,
		Email:   email,
		Role:    role,
		SubRole: subRole,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			NotBefore: jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtSecret)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

// ValidateJWT memvalidasi string token dan mengembalikan klaim jika valid
func ValidateJWT(tokenString string) (*JWTClaims, error) {
	jwtSecret := []byte(config.AppConfig.JWTSecret)

	token, err := jwt.ParseWithClaims(tokenString, &JWTClaims{}, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("metode penandatanganan tidak valid")
		}
		return jwtSecret, nil
	})

	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(*JWTClaims); ok && token.Valid {
		return claims, nil
	}

	return nil, errors.New("token tidak valid atau sudah kadaluarsa")
}
