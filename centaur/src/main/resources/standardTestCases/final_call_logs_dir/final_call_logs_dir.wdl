task hello {
  command <<<
    echo "Hello " > test.out
    echo "Hello " > array.out
    echo "Hello " > map.out
    echo "Hello " > left.out
    echo "Hello " > right.out
  >>>
  output {
    File out = "test.out"
    Array[File] array_out = ["array.out"]
    Map[String, File] map_out = { "key": "map.out" }
    Pair[File, File] pair_out = ("left.out", "right.out")
  }
  runtime {
    docker: "us.gcr.io/broad-dsde-cromwell-dev/centaur/ubuntu:12022020-for-cromwell-tests"
  }
}

workflow wf_hello {
  call hello
  output {
     File out = hello.out
     Array[File] array_out = hello.array_out
     Map[String, File] map_out = hello.map_out
     Pair[File, File] pair_out = hello.pair_out
  }
}
