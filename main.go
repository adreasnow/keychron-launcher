package main

import (
	"os"
	"os/exec"
)

func main() {
	cmd := exec.Command("open", "-a", "Keychron Launcher")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
}
