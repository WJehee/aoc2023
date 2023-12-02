package main

import (
    "fmt"
    "os"
    "log"
    "bufio"
    "strings"
    "strconv"
)

const (
    redCubes = 12
    greenCubes = 13
    blueCubes = 14
)

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func main() {
    file, err := os.Open("input.txt")
    if err != nil {
        log.Fatal("failed to read file")
    }
    defer file.Close()
    scanner := bufio.NewScanner(file)
    result1 := 0
    result2 := 0
    for scanner.Scan() {
        line := scanner.Text()
        line, _ = strings.CutPrefix(line, "Game ")
        split := strings.Split(line, ":")
        game_no, _ := strconv.Atoi(split[0])
        minRed := 0
        minGreen := 0
        minBlue := 0
        for _, value := range strings.Split(split[1], ";") {
            for _, value := range strings.Split(value, ",") {
                split := strings.Split(value, " ")
                n, _ := strconv.Atoi(split[1])
                color := split[2]
                if color == "red" {
                    minRed = max(minRed, n)
                } else if color == "green" {
                    minGreen = max(minGreen, n)
                } else if color == "blue" {
                    minBlue = max(minBlue, n)
                }
            }
        }
        fmt.Println(game_no, minRed, minGreen, minBlue)
        if 
        (minRed <= redCubes) &&
        (minGreen <= greenCubes) &&
        (minBlue <= blueCubes) {
            result1 += game_no
        }
        result2 += minRed * minGreen * minBlue
    }
    fmt.Println("Solution 1: ", result1)
    fmt.Println("Solution 2: ", result2)
}

