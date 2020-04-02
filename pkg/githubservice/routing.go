package githubservice

import (
	"github.com/gin-gonic/gin"
)

// Run runs the github service
func Run() {
	engine := gin.Default()
	engine.GET("/ping", func(c *gin.Context) {
		c.JSON(200, map[string]interface{}{
			"foo": 1,
			"bar": 2,
		})
	})
	engine.Run()
}
