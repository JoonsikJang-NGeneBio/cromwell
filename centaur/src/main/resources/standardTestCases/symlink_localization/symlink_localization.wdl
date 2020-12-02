task make_files {
  command {
    echo "hello" > bar
    ln -s bar baz
    ln -s $(pwd)/bar bam
  }

  output {
    File rel = "baz"
    File abs = "bam"
  }
}

task localize {
    File rel
    File abs
    command {
        cat ${rel}
        cat ${abs}
    }

    output {
        String out = read_string(stdout())
    }
}

task localize_with_docker {
    File rel
    File abs
    command {
        cat ${rel}
        cat ${abs}
    }

    output {
        String out = read_string(stdout())
    }
    runtime { docker: "us.gcr.io/broad-dsde-cromwell-dev/centaur/ubuntu:12022020-for-cromwell-tests" }
}

workflow symlink_localization {
   call make_files
   call localize { input: rel = make_files.rel, abs = make_files.abs }
   call localize_with_docker { input: rel = make_files.rel, abs = make_files.abs }
   output {
     String noDocker = localize.out
     String withDocker = localize_with_docker.out
   }
}
