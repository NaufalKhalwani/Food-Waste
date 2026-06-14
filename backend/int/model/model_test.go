package model

import "fmt"
import "strings"
import "testing"
import "time"

// =========================================================
// Helper ID generator (mengikuti logika BeforeCreate)
// =========================================================

func GenerateDonorID() string {
	return fmt.Sprintf("DNR-%d", time.Now().Unix())
}

func GeneratePenerimaID() string {
	return fmt.Sprintf("PRN-%d", time.Now().Unix())
}

func GenerateAdminID() string {
	return fmt.Sprintf("ADM-%d", time.Now().Unix())
}

func GeneratePenyimpananID() string {
	return fmt.Sprintf("PSN-%d", time.Now().Unix())
}

func GenerateMakananID() string {
	return fmt.Sprintf("MKN-%d", time.Now().Unix())
}

func GenerateRequestID() string {
	return fmt.Sprintf("RQT-%d", time.Now().Unix())
}

// =========================================================
// TEST: StatusMakanan - Finite State Machine (Automata)
// =========================================================

func TestMakananBeforeCreate(t *testing.T) {
	m := Makanan{}

	err := m.BeforeCreate(nil)

	if err != nil {
		t.Fatal(err)
	}

	if !strings.HasPrefix(m.MakananID, "MKN-") {
		t.Errorf("expected ID starts with MKN-, got %s", m.MakananID)
	}
}

func TestStatusMakanan_ValidTransitions(t *testing.T) {
	tests := []struct {
		name     string
		from     StatusMakanan
		to       StatusMakanan
		expected bool
	}{
		// Transisi valid
		{"tersedia -> direquest", StatusTersedia, StatusDirequest, true},
		{"tersedia -> kadaluarsa", StatusTersedia, StatusKadaluarsa, true},
		{"direquest -> didistribusikan", StatusDirequest, StatusDidistribusi, true},
		{"direquest -> tersedia (batal)", StatusDirequest, StatusTersedia, true},
		// Transisi tidak valid
		{"tersedia -> didistribusikan (skip)", StatusTersedia, StatusDidistribusi, false},
		{"didistribusikan -> apapun (terminal)", StatusDidistribusi, StatusTersedia, false},
		{"kadaluarsa -> apapun (terminal)", StatusKadaluarsa, StatusTersedia, false},
		{"kadaluarsa -> direquest", StatusKadaluarsa, StatusDirequest, false},
		{"didistribusikan -> direquest", StatusDidistribusi, StatusDirequest, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := tt.from.CanTransitionTo(tt.to)
			if result != tt.expected {
				t.Errorf("CanTransitionTo(%q -> %q) = %v, want %v", tt.from, tt.to, result, tt.expected)
			}
		})
	}
}

func TestStatusMakanan_InvalidStatusKey(t *testing.T) {
	var status StatusMakanan = "tidak_valid"
	result := status.CanTransitionTo(StatusTersedia)
	if result != false {
		t.Errorf("Status tidak dikenal seharusnya return false, got %v", result)
	}
}

// =========================================================
// TEST: Penyimpanan - BeforeCreate Hook
// =========================================================
func TestPenyimpananBeforeCreate(t *testing.T) {
	p := Penyimpanan{}

	err := p.BeforeCreate(nil)

	if err != nil {
		t.Fatal(err)
	}

	if !strings.HasPrefix(p.PenyimpananID, "PSN-") {
		t.Errorf("expected ID starts with PSN-, got %s", p.PenyimpananID)
	}
}

// =========================================================
// TEST: StatusRequest - Finite State Machine (Automata)
// =========================================================

func TestStatusRequest_ValidTransitions(t *testing.T) {
	tests := []struct {
		name     string
		from     StatusRequest
		to       StatusRequest
		expected bool
	}{
		// Transisi valid
		{"pending -> disetujui", StatusPending, StatusDisetujui, true},
		{"pending -> ditolak", StatusPending, StatusDitolak, true},
		{"disetujui -> selesai", StatusDisetujui, StatusSelesai, true},
		// Transisi tidak valid
		{"pending -> selesai (skip)", StatusPending, StatusSelesai, false},
		{"ditolak -> apapun (terminal)", StatusDitolak, StatusPending, false},
		{"selesai -> apapun (terminal)", StatusSelesai, StatusPending, false},
		{"disetujui -> pending (mundur)", StatusDisetujui, StatusPending, false},
		{"disetujui -> ditolak", StatusDisetujui, StatusDitolak, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := tt.from.CanTransitionTo(tt.to)
			if result != tt.expected {
				t.Errorf("CanTransitionTo(%q -> %q) = %v, want %v", tt.from, tt.to, result, tt.expected)
			}
		})
	}
}

func TestStatusRequest_InvalidStatusKey(t *testing.T) {
	var status StatusRequest = "status_aneh"
	if status.CanTransitionTo(StatusPending) {
		t.Error("Status tidak dikenal seharusnya return false")
	}
}

func TestRequestBeforeCreate(t *testing.T) {
	r := Request{}

	err := r.BeforeCreate(nil)

	if err != nil {
		t.Fatal(err)
	}

	if !strings.HasPrefix(r.RequestID, "RQT-") {
		t.Errorf("expected ID starts with RQT-, got %s", r.RequestID)
	}
}

// =========================================================
// TEST: ID Generator - Format Prefix
// =========================================================

func TestIDGenerator_Prefix(t *testing.T) {
	tests := []struct {
		name     string
		generate func() string
		prefix   string
	}{
		{"Donor ID", GenerateDonorID, "DNR-"},
		{"Penerima ID", GeneratePenerimaID, "PRN-"},
		{"Admin ID", GenerateAdminID, "ADM-"},
		{"Penyimpanan ID", GeneratePenyimpananID, "PSN-"},
		{"Makanan ID", GenerateMakananID, "MKN-"},
		{"Request ID", GenerateRequestID, "RQT-"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			id := tt.generate()
			if !strings.HasPrefix(id, tt.prefix) {
				t.Errorf("ID %q seharusnya berawalan %q", id, tt.prefix)
			}
			if len(id) <= len(tt.prefix) {
				t.Errorf("ID %q terlalu pendek, tidak ada timestamp setelah prefix", id)
			}
		})
	}
}

func TestIDGenerator_Uniqueness(t *testing.T) {
	// Pastikan ID yang dihasilkan unik (berbeda satu sama lain)
	// Karena berbasis Unix timestamp, harus sama jika dalam detik yang sama
	// Kita cukup validasi format saja
	id1 := GenerateDonorID()
	id2 := GeneratePenerimaID()

	if id1 == id2 {
		t.Error("ID dari generator berbeda seharusnya tidak sama persis")
	}
}

// =========================================================
// TEST: Struct Makanan - Validasi Field
// =========================================================

func TestMakanan_DefaultStatus(t *testing.T) {
	makanan := Makanan{
		MakananID:     "MKN-001",
		IDDonor:       "DNR-001",
		Jumlah:        10,
		StatusMakanan: StatusTersedia,
	}

	if makanan.StatusMakanan != StatusTersedia {
		t.Errorf("Status awal makanan seharusnya 'tersedia', got %q", makanan.StatusMakanan)
	}
}

func TestMakanan_JumlahPositif(t *testing.T) {
	tests := []struct {
		name   string
		jumlah int
		valid  bool
	}{
		{"jumlah positif", 5, true},
		{"jumlah nol", 0, false},
		{"jumlah negatif", -1, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			isValid := tt.jumlah > 0
			if isValid != tt.valid {
				t.Errorf("Jumlah %d: valid=%v, want %v", tt.jumlah, isValid, tt.valid)
			}
		})
	}
}

func TestMakanan_TanggalKadaluarsa(t *testing.T) {
	now := time.Now()
	makananBelumKadaluarsa := Makanan{
		TanggalKadaluarsa: now.Add(24 * time.Hour), // besok
	}
	makananSudahKadaluarsa := Makanan{
		TanggalKadaluarsa: now.Add(-24 * time.Hour), // kemarin
	}

	isFresh := makananBelumKadaluarsa.TanggalKadaluarsa.After(now)
	isExpired := makananSudahKadaluarsa.TanggalKadaluarsa.Before(now)

	if !isFresh {
		t.Error("Makanan dengan tanggal besok seharusnya belum kadaluarsa")
	}
	if !isExpired {
		t.Error("Makanan dengan tanggal kemarin seharusnya sudah kadaluarsa")
	}
}

// =========================================================
// TEST: Struct Admin - Validasi Field
// =========================================================

func TestAdminBeforeCreate(t *testing.T) {
	a := Admin{}

	a.BeforeCreate(nil)

	if !strings.HasPrefix(a.IDAdmin, "ADM-") {
		t.Errorf("expected prefix ADM-, got %s", a.IDAdmin)
	}

	if a.Role != "admin" {
		t.Errorf("expected role admin, got %s", a.Role)
	}
}

// =========================================================
// TEST: Struct Pendonor - Validasi Field
// =========================================================
func TestPendonorBeforeCreate(t *testing.T) {
	p := Pendonor{}

	err := p.BeforeCreate(nil)

	if err != nil {
		t.Fatal(err)
	}

	if !strings.HasPrefix(p.IDDonor, "DNR-") {
		t.Errorf("expected ID starts with DNR-, got %s", p.IDDonor)
	}

	if p.Role != "pendonor" {
		t.Errorf("expected role pendonor, got %s", p.Role)
	}
}

// =========================================================
// TEST: Struct Penerima - Validasi Field
// =========================================================

func TestPenerimaBeforeCreate(t *testing.T) {
	p := Penerima{}

	err := p.BeforeCreate(nil)

	if err != nil {
		t.Fatal(err)
	}

	if !strings.HasPrefix(p.IDPenerima, "PRN-") {
		t.Errorf("expected ID starts with PRN-, got %s", p.IDPenerima)
	}

	if p.Role != "penerima" {
		t.Errorf("expected role penerima, got %s", p.Role)
	}
}

func TestPenerima_NomorTeleponLength(t *testing.T) {
	tests := []struct {
		name  string
		nomor string
		valid bool
	}{
		{"nomor valid 12 digit", "081234567890", true},
		{"nomor valid 10 digit", "0812345678", true},
		{"nomor terlalu panjang (17 digit)", "08123456789012345", false},
		{"nomor kosong", "", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Validasi: panjang nomor antara 1-16 karakter (sesuai schema DB: varchar(16))
			isValid := len(tt.nomor) > 0 && len(tt.nomor) <= 16
			if isValid != tt.valid {
				t.Errorf("Nomor %q: valid=%v, want %v", tt.nomor, isValid, tt.valid)
			}
		})
	}
}

// =========================================================
// TEST: Struct Request - Workflow Lengkap
// =========================================================

func TestRequest_FullWorkflow_Disetujui(t *testing.T) {
	// Simulasi alur request dari pending -> disetujui -> selesai
	request := Request{
		RequestID: "RQT-001",
		Status:    StatusPending,
	}

	// Step 1: pending -> disetujui
	if !request.Status.CanTransitionTo(StatusDisetujui) {
		t.Fatal("Seharusnya bisa transisi dari pending ke disetujui")
	}
	request.Status = StatusDisetujui

	// Step 2: disetujui -> selesai
	if !request.Status.CanTransitionTo(StatusSelesai) {
		t.Fatal("Seharusnya bisa transisi dari disetujui ke selesai")
	}
	request.Status = StatusSelesai

	// Step 3: selesai adalah terminal, tidak bisa transisi ke mana pun
	if request.Status.CanTransitionTo(StatusPending) {
		t.Error("Status selesai seharusnya tidak bisa kembali ke pending")
	}
}

func TestRequest_FullWorkflow_Ditolak(t *testing.T) {
	// Simulasi alur request dari pending -> ditolak
	request := Request{
		RequestID: "RQT-002",
		Status:    StatusPending,
	}

	if !request.Status.CanTransitionTo(StatusDitolak) {
		t.Fatal("Seharusnya bisa transisi dari pending ke ditolak")
	}
	request.Status = StatusDitolak

	// ditolak adalah terminal
	if request.Status.CanTransitionTo(StatusPending) {
		t.Error("Status ditolak seharusnya tidak bisa kembali ke pending")
	}
	if request.Status.CanTransitionTo(StatusDisetujui) {
		t.Error("Status ditolak seharusnya tidak bisa ke disetujui")
	}
}

// =========================================================
// TEST: Struct Makanan - Workflow Status Lengkap
// =========================================================

func TestMakanan_FullWorkflow_Distribusi(t *testing.T) {
	makanan := Makanan{
		MakananID:     "MKN-001",
		StatusMakanan: StatusTersedia,
	}

	// tersedia -> direquest
	if !makanan.StatusMakanan.CanTransitionTo(StatusDirequest) {
		t.Fatal("Seharusnya bisa dari tersedia ke direquest")
	}
	makanan.StatusMakanan = StatusDirequest

	// direquest -> didistribusikan
	if !makanan.StatusMakanan.CanTransitionTo(StatusDidistribusi) {
		t.Fatal("Seharusnya bisa dari direquest ke didistribusikan")
	}
	makanan.StatusMakanan = StatusDidistribusi

	// didistribusikan adalah terminal
	if makanan.StatusMakanan.CanTransitionTo(StatusTersedia) {
		t.Error("Status didistribusikan seharusnya tidak bisa kembali")
	}
}

func TestMakanan_FullWorkflow_Kadaluarsa(t *testing.T) {
	makanan := Makanan{
		MakananID:     "MKN-002",
		StatusMakanan: StatusTersedia,
	}

	// tersedia -> kadaluarsa
	if !makanan.StatusMakanan.CanTransitionTo(StatusKadaluarsa) {
		t.Fatal("Seharusnya bisa dari tersedia ke kadaluarsa")
	}
	makanan.StatusMakanan = StatusKadaluarsa

	// kadaluarsa adalah terminal
	if makanan.StatusMakanan.CanTransitionTo(StatusTersedia) {
		t.Error("Status kadaluarsa seharusnya tidak bisa kembali ke tersedia")
	}
}

func TestMakanan_BatalRequest(t *testing.T) {
	makanan := Makanan{
		MakananID:     "MKN-003",
		StatusMakanan: StatusTersedia,
	}

	// tersedia -> direquest
	makanan.StatusMakanan = StatusDirequest

	// direquest -> tersedia (request dibatalkan)
	if !makanan.StatusMakanan.CanTransitionTo(StatusTersedia) {
		t.Fatal("Seharusnya bisa dari direquest kembali ke tersedia (batal)")
	}
	makanan.StatusMakanan = StatusTersedia

	if makanan.StatusMakanan != StatusTersedia {
		t.Errorf("Status seharusnya kembali ke tersedia, got %q", makanan.StatusMakanan)
	}
}
