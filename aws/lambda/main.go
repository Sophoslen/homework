package main

import (
	"context"
	"fmt"
	"time"
	"os"
	"strconv"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	redis "github.com/go-redis/redis/v8"
) 

func main(){
	handler := controlStruct{}
	lambda.Start(handler.Handler)
}

type controlStruct struct{}

func (h *controlStruct) Handler(ctx context.Context, event events.S3Event) error {

	numDB, err := strconv.Atoi(os.Getenv("redisDB"))
	if err != nil {
		fmt.Println("no se pudo pasear la var de entorno redisdb a entero")
		return err
	}
	redisDB := redis.NewClient(&redis.Options{
		Addr: os.Getenv("redisHost"),//con :6379 al final
		Username: os.Getenv("username"),
		Password: os.Getenv("password"),
		DB: numDB,
	})
	
	for _, elem := range event.Records {
		fmt.Print(elem.S3.Object.Key)
		_, err := redisDB.Set(ctx, "fileName", elem.S3.Object.Key, 15 * time.Minute).Result()
		if err != nil {
			fmt.Println("hubo un error guardando el objeto en redis", err.Error())
			return err
		}
		fmt.Println("el guardado fue exitoso", elem.S3.Object.Key)
	}
	return nil
}

