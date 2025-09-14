# PregnancyCare - Maternal Health Record System

A secure blockchain-based system for tracking maternal health records during pregnancy, built on Stacks to ensure data integrity and authorized access.

## Features

- **Comprehensive Health Tracking**: Record vital signs, measurements, and observations
- **Provider Authorization**: Only authorized healthcare providers can add records
- **Risk Assessment**: Automatic identification of high-risk health indicators
- **Appointment Scheduling**: Track next appointment dates
- **Patient History**: Complete pregnancy care timeline for each patient

## Health Metrics Tracked

- Gestational age and visit dates
- Blood pressure (systolic/diastolic)
- Maternal weight and fundal height
- Fetal heart rate monitoring
- Provider notes and observations
- Next appointment scheduling

## Contract Functions

### Public Functions
- `authorize-provider(provider)` - Authorize healthcare provider (owner only)
- `add-care-record(...)` - Add new pregnancy care record (providers only)

### Read-Only Functions
- `get-care-record(patient, record-id)` - Retrieve specific care record
- `get-latest-record(patient)` - Get patient's most recent record
- `get-patient-record-count(patient)` - Get total number of patient records
- `is-authorized-provider(provider)` - Check provider authorization
- `get-next-appointment(patient)` - Get scheduled next appointment
- `has-high-risk-indicators(patient)` - Check for high-risk health indicators

## High-Risk Indicators

The system automatically flags patients with:
- High blood pressure (>140/90 mmHg)
- Abnormal fetal heart rate (<120 or >160 bpm)
- Other configurable risk factors

## Usage

1. Deploy contract and authorize healthcare providers
2. Providers add care records during patient visits
3. Track patient health progression throughout pregnancy
4. Monitor for high-risk indicators requiring immediate attention
5. Schedule and track follow-up appointments

## Privacy & Security

- Provider-only record creation
- Patient-specific data access
- Immutable health record history
- Secure principal-based authentication

## License

MIT License