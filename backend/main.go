package main

import (
	"log" //mencatat log error

	"anti-food-waste2.0/int/config"   //import package config
	"anti-food-waste2.0/int/db"       // import package database
	"anti-food-waste2.0/int/handlers" // import package handlers

	"github.com/gin-gonic/gin" //import framework  Gin
)

func main() {
	//runtime config
	config.Load()

	//koneksi,migrasi db,code reuse/library
	db.Connect()
	db.Migrate()

	//setup gin,runtime config
	if config.AppConfig.AppEnv == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	router := gin.Default()

	//API
	router.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		c.Header("Access-Control-Allow-Headers", "Origin, Content-Type, Authorization")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()

	})
	//mendaftarkan route untuk API
	handlers.SetupRoutes(router)

	//menjalankan server http,runtime config
	addr := ":" + config.AppConfig.AppPort
	log.Printf(" Anti Food Waste API berjalan di http://localhost%s", addr)
	log.Printf(" Environment: %s", config.AppConfig.AppEnv)

	if err := router.Run(addr); err != nil {
		log.Fatalf("Server gagal dijalankan: %v", err)
	}
}
