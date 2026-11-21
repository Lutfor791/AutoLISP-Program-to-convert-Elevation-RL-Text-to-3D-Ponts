;;; MTextTo3DPoints - candidate enhancement for AutoCAD testing
;;; Converts numeric MTEXT on the current tab to 3D POINT entities.
;;; X/Y = MTEXT insertion point; Z = numeric text value.
;;; IMPORTANT: Does not deduplicate points. Run on a backup drawing.
;;; Requires AutoCAD with Visual LISP/ActiveX support.

(defun c:MTextTo3DPoints
  (/ ss i e obj textStr zValue insPt newPt created skipped result)
  (vl-load-com)
  (setq created 0
        skipped 0)
  (princ "\nConverting numeric MTEXT to 3D points...")
  (setq ss (ssget "_X" (list '(0 . "MTEXT") (cons 410 (getvar "CTAB")))))

  (if ss
    (progn
      (setq i (sslength ss))
      (repeat i
        (setq e (ssname ss (setq i (1- i))))
        (setq obj (vlax-ename->vla-object e))
        (setq textStr (vlax-get-property obj 'TextString))
        (setq insPt
          (vlax-safearray->list
            (vlax-variant-value (vlax-get-property obj 'InsertionPoint))
          )
        )

        ;; Plain numeric MTEXT only; formatting, prefixes and units are
        ;; not automatically interpreted as elevation values.
        (setq textStr (vl-string-trim " \t\r\n" textStr))
        (setq zValue (distof textStr))

        (if (and zValue (>= (length insPt) 2))
          (progn
            (setq newPt (list (car insPt) (cadr insPt) zValue))
            (setq result (entmake (list '(0 . "POINT") (cons 10 newPt))))
            (if result
              (setq created (1+ created))
              (setq skipped (1+ skipped))
            )
          )
          (setq skipped (1+ skipped))
        )
      )
      (progn
        (princ (strcat "\nCreated 3D points: " (itoa created)))
        (princ (strcat "\nSkipped MTEXT objects: " (itoa skipped)))
      )
    )
    (princ "\nNo MTEXT objects found in the current tab.")
  )
  (princ)
)
