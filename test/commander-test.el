(require 'ert)
(require 'el-mock)
(require 'commander (expand-file-name "commander.el" (directory-file-name default-directory)))

(ert-deftest test-commander-option-present-long ()
  (with-mock
   (mock (help) :times 1)
   (commander
    (option "--help" "HELP" 'help)
    (parse '("--help")))))

(ert-deftest test-commander-option-present-short ()
  (with-mock
   (mock (help) :times 1)
   (commander
    (option "-h" "HELP" 'help)
    (parse '("-h")))))

(ert-deftest test-commander-option-present-with-others ()
  (with-mock
   (mock (help) :times 1)
   (commander
    (option "--before" "BEFORE" 'ignore)
    (option "--after" "AFTER" 'ignore)
    (option "--help" "HELP" 'help)
    (parse '("--before" "--help" "--after")))))

(ert-deftest test-commander-option-alias ()
  (with-mock
   (mock (help) :times 2)
   (commander
    (option "--help, -h" "HELP" 'help)
    (parse '("--help"))
    (parse '("-h")))))

(ert-deftest test-commander-option-none ()
  (with-mock
   (not-called help)
   (commander
    (option "--help" "HELP" 'help)
    (parse nil))))

(ert-deftest test-commander-option-not-present ()
  (with-mock
   (mock (error "Option `%s` not available" "--do-not-help"))
   (commander
    (option "--help" "HELP" 'help)
    (parse '("--do-not-help")))))

(ert-deftest test-commander-required-argument-present ()
  (with-mock
   (mock (help "command") :times 1)
   (commander
    (option "--help <command>" "COMMAND HELP" 'help)
    (parse '("--help" "command")))))

(ert-deftest test-commander-required-argument-present-with-friends ()
  (with-mock
   (mock (help "command") :times 1)
   (commander
    (option "--help <command>" "COMMAND HELP" 'help)
    (option "--before" "BEFORE" 'ignore)
    (option "--after" "AFTER" 'ignore)
    (parse '("--before" "--help" "command" "--after")))))

(ert-deftest test-commander-required-argument-not-present-next-is-option ()
  (with-mock
   (mock (help "--command") :times 1)
   (commander
    (option "--help <command>" "COMMAND HELP" 'help)
    (parse '("--help" "--command")))))

(ert-deftest test-commander-required-argument-not-present ()
  (with-mock
   (mock (error "Option `%s` requires argument" "--help") :times 1)
   (commander
    (option "--help <command>" "COMMAND HELP" 'help)
    (parse '("--help")))))

(ert-deftest test-commander-optional-argument-present ()
  (with-mock
   (mock (help "command") :times 1)
   (commander
    (option "--help [command]" "COMMAND HELP" 'help)
    (parse '("--help" "command")))))

(ert-deftest test-commander-optional-argument-not-present ()
  (with-mock
   (mock (help) :times 1)
   (commander
    (option "--help [command]" "COMMAND HELP" 'help)
    (parse '("--help")))))

(ert-deftest test-commander-optional-argument-not-present-with-default-value ()
  (with-mock
   (mock (help "all") :times 1)
   (commander
    (option "--help [command]" "COMMAND HELP" 'help "all")
    (parse '("--help")))))

(ert-deftest test-commander-mixed-with-noise ()
  (with-mock
   (mock (x) :times 1)
   (mock (help "bar") :times 1)
   (mock (show "baz") :times 1)
   (commander
    (option "-x" "X" 'x)
    (option "--show <command>" "SHOW" 'show)
    (option "--help [command]" "HELP" 'help)
    (parse '("foo" "-x" "--help" "bar" "--show" "baz" "qux")))))

(ert-deftest test-commander-parse-expression ()
  (let ((arguments '("--help")))
    (with-mock
     (mock (help) :times 1)
     (commander
      (option "--help" "HELP" 'help)
      (parse arguments)))))

(ert-run-tests-batch-and-exit)