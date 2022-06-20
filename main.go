package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

type CtfService struct {
	Db *sql.DB
}

type Juice struct {
	ID   int
	Name string
}

func (cs *CtfService) Get(c *gin.Context) {
	id := c.Param("id")
	var juices []Juice
	query := fmt.Sprintf("SELECT * FROM juice WHERE id = '%s'", id)
	rows, err := cs.Db.Query(query)
	if err != nil {
		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}

	} else {
		defer rows.Close()
		for rows.Next() {
			var juice Juice
			err := rows.Scan(&juice.ID, &juice.Name)
			if err == nil {
				juices = append(juices, juice)
			}
		}
		c.JSON(http.StatusOK, gin.H{"result": juices})
	}
}

func initDb() *sql.DB {
	connStr := "host=postgresql user=postgres dbname=juice_market sslmode=disable"
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	return db
}

func setupRouter() *gin.Engine {
	r := gin.Default()
	db := initDb()
	service := CtfService{Db: db}

	r.GET("/ping", func(c *gin.Context) {
		c.String(http.StatusOK, "pong")
	})

	r.GET("/juice/:id", service.Get)

	return r
}

func main() {
	r := setupRouter()
	r.Run(":8080")
}
