package handlers

import "net/http" // Digunakan untuk mengirimkan standard response HTTP (seperti StatusOK)
import "github.com/gin-gonic/gin" // Gin framework yang digunakan untuk membuat web server (routing)

func SetupRoutes(r *gin.Engine) {
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok", "service": "Anti Food Waste API"})
	})

	// grouping endpoint API
	api := r.Group("/api")

	// pendonor
	api.POST("/Register/pendonor", CreatePendonor)
	api.POST("/Login/pendonor", LoginPendonor)

	// penerima
	api.POST("/Register/penerima", CreatePenerima)
	api.POST("/Login/penerima", LoginPenerima)

	// admin
	api.POST("/Register/admin", CreateAdmin)
	api.POST("/Login/admin", LoginAdmin)

	// pendonor management
	api.GET("/pendonor", JWTAuthMiddleware("admin", "user"), GetPendonor)
	api.DELETE("/pendonor/:id_donor", JWTAuthMiddleware("admin"), DeletePendonor)
	api.PUT("/pendonor/:id_donor", JWTAuthMiddleware("admin", "pendonor"), UpdatePendonor)

	// penerima management
	api.GET("/penerima", JWTAuthMiddleware("admin"), GetPenerimas)
	api.DELETE("/penerima/:id_penerima", JWTAuthMiddleware("admin"), DeletePenerima)
	api.PUT("/penerima/:id_penerima", JWTAuthMiddleware("admin", "penerima"), UpdatePenerima)

	// admin management
	api.GET("/admin", JWTAuthMiddleware("admin"), GetAdmins)

	// penyimpanan
	api.POST("/penyimpanan", JWTAuthMiddleware("admin"), CreatePenyimpanan)
	api.GET("/penyimpanan", JWTAuthMiddleware("admin", "user"), GetPenyimpanans)
	api.DELETE("/penyimpanan/:penyimpanan_id", JWTAuthMiddleware("admin"), DeletePenyimpanan)
	api.PUT("/penyimpanan/:penyimpanan_id", JWTAuthMiddleware("admin"), UpdatePenyimpanan)

	// makanan
	api.POST("/makanan", JWTAuthMiddleware("pendonor"), CreateMakanan)
	api.GET("/makanan", JWTAuthMiddleware("admin", "user"), GetMakanans)
	api.DELETE("/makanan/:makanan_id", JWTAuthMiddleware("admin", "pendonor"), DeleteMakanan)
	api.PUT("/makanan/:makanan_id", JWTAuthMiddleware("admin", "pendonor"), UpdateMakanan)

	// request
	api.POST("/request", JWTAuthMiddleware("penerima"), CreateRequest)
	api.GET("/request", JWTAuthMiddleware("admin", "penerima"), GetRequests)
	api.DELETE("/request/:request_id", JWTAuthMiddleware("admin", "penerima"), DeleteRequest)
	api.PUT("/request/:request_id", JWTAuthMiddleware("admin", "penerima"), UpdateRequest)
}
