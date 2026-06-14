package model

import "fmt"
import "time"
import "gorm.io/gorm"

// parameterization
type IDField[T any] struct {
	ID T `json:"id"`
}

// parameterization
type PaginatedResult[T any] struct {
	Data       []T   `json:"data"`
	TotalCount int64 `json:"total_count"`
	Page       int   `json:"page"`
	PageSize   int   `json:"page_size"`
}

type Pendonor struct {
	IDDonor        string `gorm:"primaryKey;type:varchar(255);column:id_donor" json:"id_donor"`
	NamaPendonor   string `gorm:"type:varchar(255);column:nama_pendonor" json:"nama_pendonor"`
	EmailPendonor  string `gorm:"type:varchar(255);column:email_pendonor" json:"email_pendonor"`
	Password       string `gorm:"type:varchar(255);column:password" json:"password"`
	AlamatPendonor string `gorm:"type:varchar(255);column:alamat_pendonor" json:"alamat_pendonor"`
	Role           string `gorm:"type:varchar(50);column:role" json:"role"`
}

func (Pendonor) TableName() string { return "pendonor" }

func (p *Pendonor) BeforeCreate(tx *gorm.DB) (err error) {
	p.IDDonor = fmt.Sprintf("DNR-%d", time.Now().Unix())
	if p.Role == "" {
		p.Role = "pendonor"
	}
	return
}

type Penerima struct {
	IDPenerima    string `gorm:"primaryKey;type:varchar(255);column:id_penerima" json:"id_penerima"`
	NamaPenerima  string `gorm:"type:varchar(255);column:nama_penerima" json:"nama_penerima"`
	EmailPenerima string `gorm:"type:varchar(255);column:email_penerima" json:"email"`
	Password      string `gorm:"type:varchar(255);column:password" json:"password"`
	Alamat        string `gorm:"type:varchar(255);column:alamat" json:"alamat"`
	NomorTelfon   string `gorm:"type:varchar(16);column:nomor_telfon" json:"nomor_telfon"`
	Role          string `gorm:"type:varchar(50);column:role" json:"role"`
}

func (Penerima) TableName() string { return "penerima" }

func (p *Penerima) BeforeCreate(tx *gorm.DB) (err error) {
	p.IDPenerima = fmt.Sprintf("PRN-%d", time.Now().Unix())
	if p.Role == "" {
		p.Role = "penerima"
	}
	return
}

type Admin struct {
	IDAdmin    string `gorm:"primaryKey;type:varchar(255);column:id_admin" json:"id_admin"`
	NamaAdmin  string `gorm:"type:varchar(25);column:username" json:"NamaAdmin"`
	EmailAdmin string `gorm:"type:varchar(255);column:email_admin" json:"email_admin"`
	Password   string `gorm:"type:varchar(255);column:password" json:"password"`
	Role       string `gorm:"type:varchar(50);column:role" json:"role"`
}

func (Admin) TableName() string { return "admin" }

func (p *Admin) BeforeCreate(tx *gorm.DB) (err error) {
	p.IDAdmin = fmt.Sprintf("ADM-%d", time.Now().Unix())
	if p.Role == "" {
		p.Role = "admin"
	}
	return
}

type Penyimpanan struct {
	PenyimpananID string `gorm:"primaryKey;type:varchar(255);column:penyimpanan_id" json:"penyimpanan_id"`
	IDAdmin       string `gorm:"type:varchar(255);column:id_admin" json:"id_admin"`
	NamaTempat    string `gorm:"type:varchar(255);column:nama_tempat" json:"nama_tempat"`
	Alamat        string `gorm:"type:varchar(255);column:alamat" json:"alamat"`
	Kapasitas     int    `gorm:"type:integer;column:kapasitas" json:"kapasitas"`
}

func (Penyimpanan) TableName() string { return "penyimpanan" }

func (p *Penyimpanan) BeforeCreate(tx *gorm.DB) (err error) {
	p.PenyimpananID = fmt.Sprintf("PSN-%d", time.Now().Unix())
	return
}

// automoata
type StatusMakanan string

const (
	StatusTersedia     StatusMakanan = "tersedia"
	StatusDirequest    StatusMakanan = "direquest"
	StatusDidistribusi StatusMakanan = "didistribusikan"
	StatusKadaluarsa   StatusMakanan = "kadaluarsa"
)

// Table driven
var validTransitions = map[StatusMakanan][]StatusMakanan{
	StatusTersedia:     {StatusDirequest, StatusKadaluarsa},
	StatusDirequest:    {StatusDidistribusi, StatusTersedia},
	StatusDidistribusi: {},
	StatusKadaluarsa:   {},
}

func (s StatusMakanan) CanTransitionTo(next StatusMakanan) bool {
	allowed, ok := validTransitions[s]
	if !ok {
		return false
	}
	for _, a := range allowed {
		if a == next {
			return true
		}
	}
	return false
}

type Makanan struct {
	MakananID         string        `gorm:"primaryKey;type:varchar(255);column:makanan_id" json:"makanan_id"`
	PenyimpananID     string        `gorm:"type:varchar(255);column:penyimpanan_id" json:"penyimpanan_id"`
	IDDonor           string        `gorm:"type:varchar(255);column:id_donor" json:"id_donor"`
	NamaMakanan       string        `gorm:"type:varchar(255);column:nama_makanan" json:"nama_makanan"`
	Kategori          string        `gorm:"type:varchar(50);column:kategori" json:"kategori"`
	Jumlah            int           `gorm:"type:integer;column:jumlah" json:"jumlah"`
	KondisiMakanan    string        `gorm:"type:varchar(20);column:kondisi_makanan" json:"kondisi_makanan"`
	StatusMakanan     StatusMakanan `gorm:"type:varchar(20);column:status_makanan" json:"status_makanan"`
	TanggalKadaluarsa time.Time     `gorm:"type:date;column:tanggal_kadaluarsa" json:"tanggal_kadaluarsa"`
	FotoMakanan       []byte        `gorm:"type:bytea;column:foto_makanan" json:"foto_makanan"`
}

func (Makanan) TableName() string { return "makanan" }

func (p *Makanan) BeforeCreate(tx *gorm.DB) (err error) {
	p.MakananID = fmt.Sprintf("MKN-%d", time.Now().Unix())
	return
}

// automata
type StatusRequest string

const (
	StatusPending   StatusRequest = "pending"
	StatusDisetujui StatusRequest = "disetujui"
	StatusDitolak   StatusRequest = "ditolak"
	StatusSelesai   StatusRequest = "selesai"
)

// table driven
var validRequestTransitions = map[StatusRequest][]StatusRequest{
	StatusPending:   {StatusDisetujui, StatusDitolak},
	StatusDisetujui: {StatusSelesai},
	StatusDitolak:   {},
	StatusSelesai:   {},
}

func (s StatusRequest) CanTransitionTo(next StatusRequest) bool {
	allowed, ok := validRequestTransitions[s]
	if !ok {
		return false
	}
	for _, a := range allowed {
		if a == next {
			return true
		}
	}
	return false
}

type Request struct {
	RequestID          string        `gorm:"primaryKey;type:varchar(255);column:request_id" json:"request_id"`
	IDAdmin            string        `gorm:"type:varchar(255);column:id_admin" json:"id_admin"`
	PenerimaIDPenerima string        `gorm:"type:varchar(255);column:penerimaid_penerima" json:"penerimaid_penerima"`
	MakananID          string        `gorm:"type:varchar(255);column:makanan_id" json:"makanan_id"`
	Status             StatusRequest `gorm:"type:varchar(255);column:status" json:"status"`
	TanggalRequest     *time.Time    `gorm:"autoCreateTime;type:date;column:tanggal_request" json:"tanggal_request"`
}

func (Request) TableName() string { return "request" }

func (p *Request) BeforeCreate(tx *gorm.DB) (err error) {
	p.RequestID = fmt.Sprintf("RQT-%d", time.Now().Unix())
	return
}
