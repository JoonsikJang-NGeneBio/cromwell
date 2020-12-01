task singleFile {
  command {
    echo hello
  }
  output {
    File out = stdout()
  }
  runtime { docker: "marketplace.gcr.io/google/ubuntu1804:latest" }
}

task listFiles {
  Array[File] manyIn
  command {
    cat ${sep=" " manyIn}
  }
  output {
    String result = read_string(stdout())
  }
  runtime { docker: "marketplace.gcr.io/google/ubuntu1804:latest" }
}

workflow oneToMany {
  call singleFile
  call listFiles { input: manyIn = [ singleFile.out ] }
}
