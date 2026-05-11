package handlers

import (
	"net/http" // Digunakan untuk mengirimkan standard response HTTP (seperti StatusOK)

	"github.com/gin-gonic/gin" // Gin framework yang digunakan untuk membuat web server (routing)
)

func SetupRoutes(r *gin.Engine) {
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok", "service": "Anti Food Waste API"})
	})

	// grouping endpoint API
	api := r.Group("/api")

	// implemnentasi API

	// pendonor
	api.POST("/pendonor", CreatePendonor)
	api.GET("/pendonor", GetPendonor)
	api.DELETE("/pendonor/:id_donor", DeletePendonor)

	// penerima
	api.POST("/penerima", CreatePenerima)
	api.GET("/penerima", GetPenerimas)
	api.DELETE("/penerima/:id_penerima", DeletePenerima)

	// admin
	api.POST("/admin", CreateAdmin)
	api.GET("/admin", GetAdmins)

	// penyimpanan
	api.POST("/penyimpanan", CreatePenyimpanan)
	api.GET("/penyimpanan", GetPenyimpanans)
	api.DELETE("/penyimpanan/:penyimpanan_id", DeletePenyimpanan)

	// makanan
	api.POST("/makanan", CreateMakanan)
	api.GET("/makanan", GetMakanans)
	api.DELETE("/makanan/:makanan_id", DeleteMakanan)
	// request
	api.POST("/request", CreateRequest)
	api.GET("/request", GetRequests)
	api.DELETE("/request/:request_id", DeleteRequest)
}
