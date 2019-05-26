package main

import (
    "fmt"
    "log"
    "net/http"
    "os/exec"
)

func active(w http.ResponseWriter, r *http.Request){
    cmd := exec.Command("/usr/bin/postfix-toolkit.sh", "monitoring_active")
    out, err := cmd.CombinedOutput()
    if err != nil {
           log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    fmt.Fprint(w,string(out))
}
func all(w http.ResponseWriter, r *http.Request){
    cmd := exec.Command("/usr/bin/postfix-toolkit.sh", "monitoring_all")
    out, err := cmd.CombinedOutput()
    if err != nil {
           log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    fmt.Fprint(w,string(out))
}

func deferred(w http.ResponseWriter, r *http.Request){
    cmd := exec.Command("/usr/bin/postfix-toolkit.sh", "monitoring_deferred")
    out, err := cmd.CombinedOutput()
    if err != nil {
           log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    fmt.Fprint(w,string(out))
}

func postqueue(w http.ResponseWriter, r *http.Request){
    cmd := exec.Command("/usr/sbin/postqueue", "-j")
    out, err := cmd.CombinedOutput()
    if err != nil {
           log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    fmt.Fprint(w,string(out))
}


func main() {
    http.HandleFunc("/active", active)
    http.HandleFunc("/all", all)
    http.HandleFunc("/deferred", deferred)
    http.HandleFunc("/postqueue", postqueue)
    http.ListenAndServe(":8080", nil)
}
