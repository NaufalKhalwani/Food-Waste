package ConfigTest

import (
	"log"     //mencatat log error
	"os"      //mengakses variabel lingkungan
	"strconv" //mengkonversi string ke tipe data lain
	"testing"
	"github.com/joho/godotenv" //memuat file .env
)

type Config struct {
	DBHost     string
	DBUser     string
	DBPassword string
	DBName     string
	DBPort     string
	AppPort    string
	AppEnv     string
	JWTSecret  string
}

var AppConfig Config

// untuk baca file .env
func Load() {
	if err := godotenv.Load(); err != nil {
		log.Printf("file .env tidak ditemukan: %v", err)
	}
	host := os.Getenv("DB_HOST")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	dbname := os.Getenv("DB_NAME")
	port := os.Getenv("DB_PORT")
	appPort := os.Getenv("APP_PORT")
	appEnv := os.Getenv("APP_ENV")
	jwtSecret := os.Getenv("JWT_SECRET")
	if jwtSecret == "" {
		jwtSecret = "supersecretkeyforantifoodwasteapp2026"
	}
	AppConfig = Config{
		DBHost:     host,
		DBUser:     user,
		DBPassword: password,
		DBName:     dbname,
		DBPort:     port,
		AppPort:    appPort,
		AppEnv:     appEnv,
		JWTSecret:  jwtSecret,
	}
}

// getEnv untuk mendapatkan nilai dari variabel lingkungan dengan fallback jika tidak ditemukan
func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

// getEnvInt untuk mendapatkan nilai integer dari variabel lingkungan dengan fallback jika tidak ditemukan atau tidak valid
func getEnvInt(key string, fallback int) int {
	if v := os.Getenv(key); v != "" {
		if i, err := strconv.Atoi(v); err == nil {
			return i
		}
	}
	return fallback
}

// getEnvFloat untuk mendapatkan nilai float64 dari variabel lingkungan dengan fallback jika tidak ditemukan atau tidak valid
func getEnvFloat(key string, fallback float64) float64 {
	if v := os.Getenv(key); v != "" {
		if f, err := strconv.ParseFloat(v, 64); err == nil {
			return f
		}
	}
	return fallback
}
