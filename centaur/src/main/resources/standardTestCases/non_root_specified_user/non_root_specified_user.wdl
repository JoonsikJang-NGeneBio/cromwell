task nobody {
  command {
    whoami
  }

  runtime {
    docker: "marketplace.gcr.io/google/ubuntu1804:latest"
    docker_user: "nobody"
  }

  output {
    String user = read_string(stdout())
  }
}

workflow woot {
  call nobody

  output {
    String nobodyUser = nobody.user
  }
}
