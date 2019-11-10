: '
Run locally using:
$ bash populatePSQL.sh
**Doesnt work on Heroku. Use populatePSQL.py instead**

This will populate the database with initial data contained within the .tab files, thus avoiding the
administrator having to input all this data via the web forms.

***NB***: Running this script will first clear the tables, including any modifications that have been
made to the data via the web app (e.g. updates to the progress and percent fields).
'

read -r -p "***WARNING***: Running this script will populate the database with initial \
data contained within the .tab files. IT WILL FIRST CLEAR THE TABLES, including any \
modifications that have been made to the data via the web app (e.g. updates to the \
progress and percent fields. Proceed? [y/n]" response
if [[ "$response" == "y" ]]
then

psql SWIFTDB <<EOF
-- Delete current data (in reverse order of foreign key relationships);
DELETE FROM tasks2deliverables;
DELETE FROM tasks;
DELETE FROM deliverables;
DELETE FROM users2partners;
DELETE FROM partners;
DELETE FROM users2work_packages;
DELETE FROM work_packages;

-- Copy new data (in normal order);
\copy partners(name,country,role) FROM './partners.tab';
\copy work_packages(code,name) FROM './work_packages.tab';
\copy deliverables(code,work_package,description,responsible_partner,month_due,progress,percent) FROM './deliverables.tab' WITH NULL AS '';
\copy tasks(code,description,responsible_partner,month_due,progress,percent) FROM './tasks.tab' WITH NULL AS '';
\copy tasks2deliverables(task,deliverable) FROM './tasks2deliverables.tab';
EOF

else
    echo you answered no
fi
