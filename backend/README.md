# Backend Starter

This backend repo uses FastAPI with separate `admin` and `user` API folders.

Structure:

- `admin/`
  - `routes/`
  - `controllers/`
  - `models/`
  - `services/`
- `user/`
  - `routes/`
  - `controllers/`
  - `models/`
  - `services/`
- `src/utils/`
  - `config.py`
  - `db.py`

Run with:

```powershell
uvicorn main:app --reload
```
