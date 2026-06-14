package handlers

import "net/http" // untuk status code HTTP
import "time"
import "anti-food-waste2.0/int/db"    // import package database
import "anti-food-waste2.0/int/model" // import package model
import "github.com/gin-gonic/gin" // import framework Gin
import "golang.org/x/crypto/bcrypt"

func CreatePendonor(c *gin.Context) { // handler pendonor
	var input model.Pendonor
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengenkripsi password"})
		return
	}
	input.Password = string(hashedPassword)

	if err := db.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	input.Password = ""
	c.JSON(http.StatusCreated, input)
}

func GetPendonor(c *gin.Context) {
	var pendonors []model.Pendonor
	db.DB.Find(&pendonors)
	c.JSON(http.StatusOK, pendonors)
}

func CreatePenerima(c *gin.Context) { // handler penerima
	var input model.Penerima
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengenkripsi password"})
		return
	}
	input.Password = string(hashedPassword)

	if err := db.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	input.Password = ""
	c.JSON(http.StatusCreated, input)
}

func GetPenerimas(c *gin.Context) {
	var penerimas []model.Penerima
	db.DB.Find(&penerimas)
	c.JSON(http.StatusOK, penerimas)
}

func CreateAdmin(c *gin.Context) { // handler admin
	var input model.Admin
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal mengenkripsi password"})
		return
	}
	input.Password = string(hashedPassword)

	if err := db.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	input.Password = ""
	c.JSON(http.StatusCreated, input)
}

func GetAdmins(c *gin.Context) {
	var admins []model.Admin
	db.DB.Find(&admins)
	c.JSON(http.StatusOK, admins)
}

func CreatePenyimpanan(c *gin.Context) { // handler penyimpanan
	var input model.Penyimpanan
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	input.IDAdmin = c.GetString("userId")

	if err := db.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, input)
}

func GetPenyimpanans(c *gin.Context) {
	var penyimpanans []model.Penyimpanan
	db.DB.Find(&penyimpanans)
	c.JSON(http.StatusOK, penyimpanans)
}

func CreateMakanan(c *gin.Context) { // handler makanan
	var input model.Makanan
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	input.IDDonor = c.GetString("userId")

	if err := db.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, input)
}

func GetMakanans(c *gin.Context) {
	now := time.Now()

	if err := db.DB.Model(&model.Makanan{}).
		Where("tanggal_kadaluarsa < ? AND status_makanan != ?", now, model.StatusKadaluarsa).
		Update("status_makanan", model.StatusKadaluarsa).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal memperbarui status makanan kadaluarsa: " + err.Error()})
		return
	}

	var makanans []model.Makanan
	if err := db.DB.Where("status_makanan = ? AND tanggal_kadaluarsa >= ?", model.StatusTersedia, now).Find(&makanans).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, makanans)
}

func CreateRequest(c *gin.Context) { // handler request
	var input model.Request
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// Ambil id penerima secara otomatis dari token JWT
	input.PenerimaIDPenerima = c.GetString("userId")
	if input.Status == "" {
		input.Status = model.StatusPending
	}

	if err := db.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, input)
}

func GetRequests(c *gin.Context) {
	var requests []model.Request
	db.DB.Find(&requests)
	c.JSON(http.StatusOK, requests)
}

func DeletePendonor(c *gin.Context) {
	id := c.Param("id_donor")
	if err := db.DB.Where("id_donor = ?", id).Delete(&model.Pendonor{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Pendonor berhasil dihapus"})
}

func DeletePendonors(c *gin.Context) {
	var pendonors []model.Pendonor
	db.DB.Find(&pendonors)
	c.JSON(http.StatusOK, pendonors)
}

func DeletePenerima(c *gin.Context) {
	id := c.Param("id_penerima")
	if err := db.DB.Where("id_penerima = ?", id).Delete(&model.Penerima{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Penerima berhasil dihapus"})
}

func DeletePenerimas(c *gin.Context) {
	var penerimas []model.Penerima
	db.DB.Find(&penerimas)
	c.JSON(http.StatusOK, penerimas)
}

func DeleteRequest(c *gin.Context) {
	id := c.Param("id_request")
	if err := db.DB.Where("id_request = ?", id).Delete(&model.Request{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Request berhasil dihapus"})
}

func DeleteRequests(c *gin.Context) {
	var requests []model.Request
	db.DB.Find(&requests)
	c.JSON(http.StatusOK, requests)
}

func DeleteMakanan(c *gin.Context) {
	id := c.Param("makanan_id")
	if err := db.DB.Where("makanan_id = ?", id).Delete(&model.Makanan{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Makanan berhasil dihapus"})
}

func DeleteMakanans(c *gin.Context) {
	var makanans []model.Makanan
	db.DB.Find(&makanans)
	c.JSON(http.StatusOK, makanans)
}

func DeletePenyimpanan(c *gin.Context) {
	id := c.Param("penyimpanan_id")
	if err := db.DB.Where("penyimpanan_id = ?", id).Delete(&model.Penyimpanan{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Penyimpanan berhasil dihapus"})
}

func DeletePenyimpanans(c *gin.Context) {
	var penyimpanans []model.Penyimpanan
	db.DB.Find(&penyimpanans)
	c.JSON(http.StatusOK, penyimpanans)
}

func UpdatePendonor(c *gin.Context) {
	id := c.Param("id_donor")
	var input model.Pendonor
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := db.DB.Model(&model.Pendonor{}).Where("id_donor = ?", id).Updates(input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Pendonor berhasil diperbarui"})
}

func UpdatePenerima(c *gin.Context) {
	id := c.Param("id_penerima")
	var input model.Penerima
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := db.DB.Model(&model.Penerima{}).Where("id_penerima = ?", id).Updates(input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Penerima berhasil diperbarui"})
}

func UpdateRequest(c *gin.Context) {
	id := c.Param("id_request")
	var input model.Request
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := db.DB.Model(&model.Request{}).Where("id_request = ?", id).Updates(input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Request berhasil diperbarui"})
}

func UpdateMakanan(c *gin.Context) {
	id := c.Param("makanan_id")
	var input model.Makanan
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := db.DB.Model(&model.Makanan{}).Where("makanan_id = ?", id).Updates(input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Makanan berhasil diperbarui"})
}

func UpdatePenyimpanan(c *gin.Context) {
	id := c.Param("penyimpanan_id")
	var input model.Penyimpanan
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := db.DB.Model(&model.Penyimpanan{}).Where("penyimpanan_id = ?", id).Updates(input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Penyimpanan berhasil diperbarui"})
}

// LoginPendonor memvalidasi kredensial pendonor dan mengembalikan token JWT
func LoginPendonor(c *gin.Context) {
	var input struct {
		Email    string `json:"email" binding:"required"`
		Password string `json:"password" binding:"required"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var pendonor model.Pendonor
	if err := db.DB.Where("email_pendonor = ?", input.Email).First(&pendonor).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Email atau password salah"})
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(pendonor.Password), []byte(input.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Email atau password salah"})
		return
	}

	// Generate JWT: Role "user", Sub-role "pendonor"
	token, err := GenerateJWT(pendonor.IDDonor, pendonor.EmailPendonor, "user", "pendonor")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal membuat token autentikasi"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"token": token,
		"user": gin.H{
			"id":       pendonor.IDDonor,
			"nama":     pendonor.NamaPendonor,
			"email":    pendonor.EmailPendonor,
			"role":     "user",
			"sub_role": "pendonor",
		},
	})
}

// LoginPenerima memvalidasi kredensial penerima dan mengembalikan token JWT
func LoginPenerima(c *gin.Context) {
	var input struct {
		Email    string `json:"email" binding:"required"`
		Password string `json:"password" binding:"required"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var penerima model.Penerima
	if err := db.DB.Where("email_penerima = ?", input.Email).First(&penerima).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Email atau password salah"})
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(penerima.Password), []byte(input.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Email atau password salah"})
		return
	}

	// Generate JWT: Role "user", Sub-role "penerima"
	token, err := GenerateJWT(penerima.IDPenerima, penerima.EmailPenerima, "user", "penerima")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal membuat token autentikasi"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"token": token,
		"user": gin.H{
			"id":       penerima.IDPenerima,
			"nama":     penerima.NamaPenerima,
			"email":    penerima.EmailPenerima,
			"role":     "user",
			"sub_role": "penerima",
		},
	})
}

// LoginAdmin memvalidasi kredensial admin dan mengembalikan token JWT
func LoginAdmin(c *gin.Context) {
	var input struct {
		Email    string `json:"email" binding:"required"`
		Password string `json:"password" binding:"required"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var admin model.Admin
	if err := db.DB.Where("email_admin = ?", input.Email).First(&admin).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Email atau password salah"})
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(admin.Password), []byte(input.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Email atau password salah"})
		return
	}

	// Generate JWT: Role "admin", Sub-role "admin"
	token, err := GenerateJWT(admin.IDAdmin, admin.EmailAdmin, "admin", "admin")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Gagal membuat token autentikasi"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"token": token,
		"user": gin.H{
			"id":       admin.IDAdmin,
			"nama":     admin.NamaAdmin,
			"email":    admin.EmailAdmin,
			"role":     "admin",
			"sub_role": "admin",
		},
	})
}
