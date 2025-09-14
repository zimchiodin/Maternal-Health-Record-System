;; Pregnancy Care Records Contract
;; Manages maternal health records and care tracking

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u300))
(define-constant err-not-found (err u301))
(define-constant err-unauthorized (err u302))
(define-constant err-invalid-record (err u303))

(define-map care-providers principal bool)
(define-map pregnancy-records
  { patient: principal, record-id: uint }
  {
    gestational-age: uint,
    blood-pressure-systolic: uint,
    blood-pressure-diastolic: uint,
    weight: uint,
    fundal-height: uint,
    fetal-heart-rate: uint,
    visit-date: uint,
    provider: principal,
    notes: (string-ascii 500),
    next-appointment: uint
  }
)

(define-map patient-record-count principal uint)

;; Authorize care provider
(define-public (authorize-provider (provider principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set care-providers provider true))
  )
)

;; Add pregnancy care record
(define-public (add-care-record
  (patient principal)
  (gestational-age uint)
  (bp-systolic uint)
  (bp-diastolic uint)
  (weight uint)
  (fundal-height uint)
  (fetal-heart-rate uint)
  (notes (string-ascii 500))
  (next-appointment uint))
  (let ((record-count (default-to u0 (map-get? patient-record-count patient)))
        (new-record-id (+ record-count u1)))
    (asserts! (default-to false (map-get? care-providers tx-sender)) err-unauthorized)
    (map-set pregnancy-records
      {patient: patient, record-id: new-record-id}
      {
        gestational-age: gestational-age,
        blood-pressure-systolic: bp-systolic,
        blood-pressure-diastolic: bp-diastolic,
        weight: weight,
        fundal-height: fundal-height,
        fetal-heart-rate: fetal-heart-rate,
        visit-date: stacks-block-height,
        provider: tx-sender,
        notes: notes,
        next-appointment: next-appointment
      }
    )
    (map-set patient-record-count patient new-record-id)
    (ok new-record-id)
  )
)

;; Get care record
(define-read-only (get-care-record (patient principal) (record-id uint))
  (map-get? pregnancy-records {patient: patient, record-id: record-id})
)

;; Get patient's latest record
(define-read-only (get-latest-record (patient principal))
  (let ((record-count (default-to u0 (map-get? patient-record-count patient))))
    (if (> record-count u0)
      (map-get? pregnancy-records {patient: patient, record-id: record-count})
      none
    )
  )
)

;; Get patient record count
(define-read-only (get-patient-record-count (patient principal))
  (default-to u0 (map-get? patient-record-count patient))
)

;; Check if provider is authorized
(define-read-only (is-authorized-provider (provider principal))
  (default-to false (map-get? care-providers provider))
)

;; Get next appointment for patient
(define-read-only (get-next-appointment (patient principal))
  (match (get-latest-record patient)
    record (some (get next-appointment record))
    none
  )
)

;; Check if patient has high-risk indicators
(define-read-only (has-high-risk-indicators (patient principal))
  (match (get-latest-record patient)
    record (or 
            (> (get blood-pressure-systolic record) u140)
            (> (get blood-pressure-diastolic record) u90)
            (< (get fetal-heart-rate record) u120)
            (> (get fetal-heart-rate record) u160))
    false
  )
)