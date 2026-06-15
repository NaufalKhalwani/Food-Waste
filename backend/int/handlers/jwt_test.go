package handlers

import (
	"testing"

	"anti-food-waste2.0/int/config"
)

func TestGenerateAndValidateJWT(t *testing.T) {
	config.AppConfig.JWTSecret = "testsecretkeyforantifoodwasteapp"

	id := "DNR-12345"
	email := "donor@example.com"
	role := "user"
	subRole := "pendonor"

	token, err := GenerateJWT(id, email, role, subRole)
	if err != nil {
		t.Fatalf("GenerateJWT failed: %v", err)
	}
	if token == "" {
		t.Fatal("GenerateJWT returned empty token")
	}

	claims, err := ValidateJWT(token)
	if err != nil {
		t.Fatalf("ValidateJWT failed: %v", err)
	}

	if claims.ID != id {
		t.Errorf("Expected ID %q, got %q", id, claims.ID)
	}
	if claims.Email != email {
		t.Errorf("Expected Email %q, got %q", email, claims.Email)
	}
	if claims.Role != role {
		t.Errorf("Expected Role %q, got %q", role, claims.Role)
	}
	if claims.SubRole != subRole {
		t.Errorf("Expected SubRole %q, got %q", subRole, claims.SubRole)
	}
}

func TestValidateInvalidJWT(t *testing.T) {
	config.AppConfig.JWTSecret = "testsecretkeyforantifoodwasteapp"

	_, err := ValidateJWT("invalidtokenstring")
	if err == nil {
		t.Error("Expected validation error for invalid token, got nil")
	}
}
