(defun c:MTextTo3DPoints ( / ss i e obj textStr zValue insPt newPt)
  (vl-load-com)
  (princ "\nConverting MText to 3D Points...")
  
  (setq ss (ssget "_X" (list '(0 . "MTEXT") (cons 410 (getvar "CTAB")))))
  
  (if ss
    (progn
      (setq i (sslength ss))
      (repeat i
        (setq e (ssname ss (setq i (1- i))))
        (setq obj (vlax-ename->vla-object e))
        
        ;; Clean text string extraction
        (setq textStr (vlax-get-property obj 'TextString))
        (setq insPt   (vlax-safearray->list (vlax-variant-value (vlax-get-property obj 'InsertionPoint))))
        
        ;; Convert string text value to real number for Z
        (setq zValue (distof textStr))
        
        (if zValue
          (progn
            ;; Combine XY of text insertion point with Z from string value
            (setq newPt (list (car insPt) (cadr insPt) zValue))
            
            ;; Create 3D POINT entity
            (entmake
              (list
                '(0 . "POINT")
                (cons 10 newPt)
              )
            )
          )
        )
      )
      (princ "\n3D Points created successfully.")
    )
    (princ "\nNo MTEXT objects found.")
  )
  (princ)
)