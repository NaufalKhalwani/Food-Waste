package config

import "os"
import "testing"


// TestGetEnvIntFallback untuk menguji fungsi getEnvInt dengan nilai yang tidak valid sehingga harus kembali ke fallback
func TestGetEnvIntFallback(t *testing.T) {
	os.Setenv("TEST_INT", "abc")

	result := getEnvInt("TEST_INT", 10)

	if result != 10 {
		t.Errorf("expected 10, got %d", result)
	}
}

// TestGetEnvFloatFallback untuk menguji fungsi getEnvFloat dengan nilai yang tidak valid sehingga harus kembali ke fallback
func TestGetEnvFloatFallback(t *testing.T) {
	os.Setenv("TEST_FLOAT", "abc")

	result := getEnvFloat("TEST_FLOAT", 1.5)

	if result != 1.5 {
		t.Errorf("expected 1.5, got %f", result)
	}
}

func TestLoadConfig(t *testing.T) {
	os.Setenv("DB_HOST", "localhost")
	os.Setenv("DB_USER", "root")
	os.Setenv("DB_PASSWORD", "123")
	os.Setenv("DB_NAME", "foodwaste")
	os.Setenv("DB_PORT", "3306")
	os.Setenv("APP_PORT", "8080")
	os.Setenv("APP_ENV", "development")

	Load()

	if AppConfig.DBHost != "localhost" {
		t.Error("DBHost tidak sesuai")
	}
}

func TestGetEnv(t *testing.T) {
	key := "TEST_ENV_VAR"
	expected := "test_value"
	os.Setenv(key, expected)
	result := getEnv(key, "default_value")
	if result != expected {
		t.Errorf("getEnv(%s) = %s; want %s", key, result, expected)
	}
}
