package githubservice

import (
	"github.com/gin-gonic/gin"
)

// Run runs the github service
func Run() {
	engine := gin.Default()
	engine.GET("/ping", func(c *gin.Context) {
		c.JSON(200, map[string]interface{}{
			"cats":  "are really great",
			"dogs":  "are cool too i guess",
			"foxes": "are definitely the best though",
		})
	})
	engine.Run()
}
