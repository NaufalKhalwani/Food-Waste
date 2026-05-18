package handlers

import (
	"net/http" // untuk status code HTTP

	"anti-food-waste2.0/int/db"    // import package database
	"anti-food-waste2.0/int/model" // import package model

	"github.com/gin-gonic/gin" // import framework Gin
)

// handler untuk setiap endpoint API, menerima request, memanggil fungsi database, dan mengembalikan response JSON
func CreatePendonor(c *gin.Context) { // handler pendonor
	var input model.Pendonor
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := db.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
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
	if err := db.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, input)
}

func GetPenerimas(c *gin.Context) {
	var penerimas []model.Penerima
	db.DB.Find(&penerimas)
	c.JSON(http.StatusOK, penerimas)
}

func CreateAdmin(c *gin.Context) { // handler admin
	var input model.RegisterAdmin
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := db.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, input)
}

func GetAdmins(c *gin.Context) {
	var admins []model.LoginAdmin
	db.DB.Find(&admins)
	c.JSON(http.StatusOK, admins)
}

func CreatePenyimpanan(c *gin.Context) { // handler penyimpanan
	var input model.Penyimpanan
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
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
	if err := db.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, input)
}

func GetMakanans(c *gin.Context) {
	var makanans []model.Makanan
	db.DB.Find(&makanans)
	c.JSON(http.StatusOK, makanans)
}

func CreateRequest(c *gin.Context) { // handler request
	var input model.Request
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
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
