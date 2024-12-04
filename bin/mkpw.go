//usr/bin/env -S go run

package main

import (
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"time"
)

func main() {
	if len(os.Args) > 2 {
		fmt.Println("Usage: go run password_generator.go [length]")
		return
	}

  var length int
  length = 16
  if len(os.Args) == 2 {
    var err error
  	length, err = strconv.Atoi(os.Args[1])
  	if err != nil {
	  	fmt.Println("Invalid length:", err)
		  return
  	}
  }

	password := generatePassword(length)
	fmt.Println(password)
}

func generatePassword(length int) string {
	rand.Seed(time.Now().UnixNano())

	var chars []rune
	chars = append(chars, []rune("abcdefghijklmnopqrstuvwxyz")...)
	chars = append(chars, []rune("ABCDEFGHIJKLMNOPQRSTUVWXYZ")...)
	chars = append(chars, []rune("0123456789")...)
	chars = append(chars, []rune("!@#$%^&*()_+=-`~[]\\{}|;':\",./<>?")...)

	var password []rune
	for i := 0; i < length; i++ {
		password = append(password, chars[rand.Intn(len(chars))])
	}

	return string(password)
}
