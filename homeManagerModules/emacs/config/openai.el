(require 'seq)
(eval-when-compile
  (require 'cl-lib)
  (require 'subr-x)
  (require 'env)
  (require 'json))

(defvar openai-buffer "*OpenAI*"
  "Buffer used for OpenAI Responses")

(defvar openai-model "mistral-small-latest"
  "Buffer used for OpenAI Responses")

(define-error 'openai-response-error "Response error for OpenAi Package")
(define-error 'openai-parsing-error "Error parsing response from OpenAi")

  ;;;###autoload
(defun openai-prompt (prompt callback)
  "Query OpenAI with PROMPT and pass PROMPT and RESPONSE into CALLBACK"
  (interactive (list (read-string "Prompt OpenAI with: ")
                     (lambda (prompt response)
                       (openai-simulate-chat prompt response))))
  (openai--request prompt callback))

(defun openai--extract-from-query (response)
  "Extract the meat and potatoes from and OpenAI RESPONSE Query"
  (condition-case err
      (let* ((choices (assoc-default 'choices response))
             (first-choice (seq-first choices))
             (message (assoc-default 'message first-choice))
             (content (assoc-default 'content message)))
        (string-trim content)
        content) ;; return content
    (error
     (signal 'openai-parsing-error err))))

(defun openai--parse-and-handle-response (status prompt callback)
  "Parse the JSON response from the OpenAI API. Ingore STATUS and pass the RESULT and PROMPT to CALLBACK"
  (ignore status)
  (goto-char 0)
  (re-search-forward "^$")
  (let ((json-response (buffer-substring-no-properties (point) (point-max))))
    (condition-case err
        (let ((parsed-response (json-read-from-string json-response)))
          (funcall callback prompt (openai--extract-from-query parsed-response))) ;; return parsed-response
      (error
       (message "JSON Parsing Error: %s" (error-message-string err))))))

(defun openai--request (prompt callback)
  "Make async request to OpenAI client using PROMPT. The RESPONSE is then parsed for content and handled in CALLBACK."
  (let* ((api-key (getenv "OPENAI_API_KEY"))
         (url-request-method (encode-coding-string "POST" 'us-ascii))
         (url-request-extra-headers `(("Content-Type" . "application/json")
                  		      	    ("Authorization" . ,(format "Bearer %s" api-key))))
         (url-request-data (json-encode
                            `((model . ,openai-model)
                              (messages . [((role . "user") (content . ,prompt))])
                              (max_tokens . 1000) ; You can adjust this as needed
                              (temperature . 0))))) ; Adjusted temperature value
    (cl-assert (not (string= "" api-key))
               t
               "Current contents of the environmental variable OPENAI_API_KEY
                are '%s' which is not an appropriate OpenAI token please ensure
                you have the correctly set the OPENAI_API_KEY variable"
               api-key)
    (url-retrieve
     "https://api.mistral.ai/v1/chat/completions"
     'openai--parse-and-handle-response (list prompt callback))))

(defun openai-simulate-chat (prompt response)
  "Simulates OpenAI Chat Style in dedicated buffer."
  (let ((buf (get-buffer-create openai-buffer)))
    (with-current-buffer buf
      (goto-char (point-max)) ;; goto end of buffer
      (insert "User: " prompt "\n\n" openai-model ": " response "\n\n")
      (help-mode)
      (setq buffer-read-only nil))
    (display-buffer buf)))

(defvar openai-mode-font-lock-keywords
  '(("\\bUser:\\b"
     (0 'font-lock-bold-face t)
     (1 'font-lock-keyword-face t))
    ("\\bResponse:\\b"
     (0 'font-lock-bold-face t)
     (1 'font-lock-keyword-face t))))

(defvar openai-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kdb "q") 'delete-window
                map)))

(define-derived-mode openai-mode help-mode "OpenAI Mode"
  "Mode for handling OpenAI responses.")

(provide 'openai)
