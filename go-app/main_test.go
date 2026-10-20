package main

import (
	"bytes"
	"io"
	"os"
	"testing"
)

func TestMainOutput(t *testing.T) {
	// main writes to os.Stdout; keep this test sequential and restore it
	// before reporting any failures.
	output, err := os.CreateTemp(t.TempDir(), "stdout")
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = output.Close() })
	original := os.Stdout
	func() {
		os.Stdout = output
		defer func() { os.Stdout = original }()
		main()
	}()
	if _, err := output.Seek(0, io.SeekStart); err != nil {
		t.Fatal(err)
	}
	got, err := io.ReadAll(output)
	if err != nil {
		t.Fatal(err)
	}
	if want := []byte("Hello, World!\n"); !bytes.Equal(got, want) {
		t.Fatalf("stdout = %q, want %q", got, want)
	}
}
