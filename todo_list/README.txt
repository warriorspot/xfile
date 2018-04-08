XFile sample database - To Do list

A standard ToDo list.  Here are a couple of examples
of how to use it in XFile

- To see only entries that are yet to be completed:
1. Switch to Data Entry mode
2. Mark -> Mark Records
3. Double click field name "done"
4. In the text field, enter "0"
5. Click Ok
6. Mark -> Show Only Marked

- To see only entries with a specific due date and category
1. Switch to Data Entry mode
2. Mark - Mark By Formula
3. Create expression "category = " with your desired category
   "AND due_date = " with your desired due date.  Only records
   matching this criteria are marked.
4. Mark -> Show Only Marked