package githubservice

import (
	"github.com/gin-gonic/gin"
)

// Run runs the github service
func Run() {
	engine := gin.Default()
	engine.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	// listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
	engine.Run()
}
