# Smart Campus — run in GitHub Codespaces

Run this Java/Spring Boot app with MySQL in your browser, without installing Java or MySQL on your computer.

## Start the application

1. On GitHub, select the branch containing this configuration, then choose **Code → Codespaces → Create codespace**. After merging the configuration, use `main`.
2. Wait for the container setup and Maven build to finish. The first setup downloads Java tooling, MySQL, and Maven dependencies.
3. In the Codespaces terminal, from the repository root, run:
   ```bash
   bash .devcontainer/start.sh
   ```
4. When Spring Boot reports that it has started, open the **Ports** tab and choose **Open in Browser** for port **8080**. Keep the forwarded port **Private**.

| Role | Username | Password |
| --- | --- | --- |
| Admin | admin | admin123 |
| Lecturer | jmwangi | lecturer123 |
| Student | alice | student123 |

Stop the app with **Ctrl+C**. Run the same start command to restart it. Stop the Codespace when finished to avoid unnecessary usage; Codespaces is subject to your GitHub plan and usage limits.

## Database and development files

- MySQL 8.4 runs in a separate container, available inside the Codespace at `db:3306`. Database and user: `smartcampus`. No MySQL port is published publicly.
- Random database passwords are created locally in ignored `.devcontainer/app.env` and `.devcontainer/db.env` files. Do not share or commit those files. They are separate from the demo login accounts above.
- The app uses MySQL through environment overrides; the archived application source remains unchanged.
- Schema creation and demo seeding happen on the first launch against an empty database. Later starts use `ddl-auto=update` without re-seeding or dropping tables.
- Database files live in a Docker named volume and survive application/container restarts. Back up important data before deleting or rebuilding a Codespace; this is a development environment, not production hosting.
- The repository currently stores its source inside `smart-campus.zip`. Setup extracts it into the ignored `smart-campus/` folder and preserves existing edits on reruns. Edits there are local to the Codespace until you deliberately add the source to Git or update the archive. Do not delete your Codespace with unsaved work.
- Build with `cd smart-campus && mvn verify`. The project currently has no automated unit tests. Check login and role pages after changes.

If a database initialization fails midway, inspect the application and database logs before retrying. Do not delete the database or force demo inserts over existing data. If credentials are missing while a database volume exists, restore the original environment files; regenerating passwords will not change the database user's password.

For an existing Codespace created before these files were added, pull the changes and use **Codespaces: Rebuild Container** from the command palette.
