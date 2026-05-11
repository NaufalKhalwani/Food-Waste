package db

import (
	"fmt" //format string untuk membuat DSN
	"log" //mencatat log error

	"anti-food-waste2.0/int/config" // import package config
	// import package models
	"anti-food-waste2.0/int/model"
	"gorm.io/driver/postgres" // driver untuk PostgreSQL
	"gorm.io/gorm"            // ORM untuk Go
	"gorm.io/gorm/logger"     // logger untuk GORM
)

var DB *gorm.DB

// koneksi ke db portgres
func Connect() {
	cfg := config.AppConfig

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable TimeZone=Asia/Jakarta",
		cfg.DBHost, cfg.DBUser, cfg.DBPassword, cfg.DBName, cfg.DBPort)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info)})
	if err != nil {
		log.Fatalf("Gagal terhubung ke database: %v", err)
	}

	DB = db
	log.Println("Berhasil terhubung ke database")
}

var migrateTargets = []interface{}{
	&model.Pendonor{},
	&model.Penerima{},
	&model.Admin{},
	&model.Penyimpanan{},
	&model.Makanan{},
	&model.Request{},
}

func Migrate() {
	err := DB.AutoMigrate(migrateTargets...)
	if err != nil {
		log.Fatalf("Gagal melakukan migrasi database: %v", err)
	}
	log.Println("Migrasi database berhasil")
}
