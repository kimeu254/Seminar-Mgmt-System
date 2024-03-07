/// <summary>
/// Page Seminar Manager Role Center (ID 50019).
/// </summary>
page 50019 "Seminar Manager Role Center"
{
    Caption = 'Seminar Manager Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control2)
            {
                part(SeminarManagerActivities; "Seminar Manager Activities")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Seminar Manager Activities';
                }
                systempart(Outlook; Outlook)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Outlook';
                }
            }
            group(Control3)
            {
                part(MySeminars; "My Seminars")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'My Seminars';
                }
                part(MyCustomers; "My Customers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'My Customers';
                }
                // part(Connect; Connect)
                // {

                // }
                systempart(MyNotes; MyNotes)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'MyNotes';
                }
            }
        }

    }

    actions
    {
        area(Embedding)
        {
            action("Seminar Registrations")
            {
                Caption = 'Seminar Registrations';
                RunObject = Page "Seminar Registration List";
                ApplicationArea = Basic, Suite;
            }
            action(Seminars)
            {
                Caption = 'Seminars';
                RunObject = Page "Seminar List";
                ApplicationArea = Basic, Suite;
            }
            action(Instructors)
            {
                Caption = 'Instructors';
                RunObject = Page "Resource List";
                RunPageView = WHERE(Type = CONST(PERSON));
                ApplicationArea = Basic, Suite;
            }
            action(Rooms)
            {
                Caption = 'Rooms';
                RunObject = Page "Resource List";
                RunPageView = WHERE(Type = CONST(MACHINE));
                ApplicationArea = Basic, Suite;
            }
            action(Customers)
            {
                Caption = 'Customers';
                RunObject = Page "Customer List";
                ApplicationArea = Basic, Suite;
            }
            action(Contacts)
            {
                Caption = 'Contacts';
                RunObject = Page "Contact List";
                ApplicationArea = Basic, Suite;
            }
        }

        area(Processing)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = RegisteredDocs;
                action("Posted Seminar Registrations")
                {
                    Caption = 'Posted Seminar Registrations';
                    RunObject = Page "Posted Seminar Registration";
                    ApplicationArea = Basic, Suite;
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                    ApplicationArea = Basic, Suite;
                }
                action(Registers)
                {
                    Caption = 'Registers';
                    RunObject = Page "Seminar Registers";
                    ApplicationArea = Basic, Suite;
                }
            }
        }

        area(Creation)
        {
            action("Seminar Registration")
            {
                Caption = 'Seminar Registration';
                RunObject = Page "Seminar Registration";
                Image = NewTimesheet;
                ApplicationArea = Basic, Suite;
            }
            action("Sales Invoice")
            {
                Caption = 'Sales Invoice';
                RunObject = Page "Sales Invoice";
                Image = NewInvoice;
                ApplicationArea = Basic, Suite;
            }
        }

        area(Sections)
        {
            group(General)
            {
                action("Create Invoices")
                {
                    Caption = 'Create Invoices';
                    //RunObject = Report "Create Seminar Invoices";
                    Image = CreateJobSalesInvoice;
                    ApplicationArea = Basic, Suite;
                }
                action(Navigate)
                {
                    Caption = 'Navigate';
                    RunObject = Page Navigate;
                    Image = Navigate;
                    ApplicationArea = Basic, Suite;
                }
            }
        }

        area(Reporting)
        {
            action("Participant List")
            {
                Caption = 'Participant List';
                RunObject = Report "Seminar Reg.-Participant List";
                Image = Report;
                ApplicationArea = Basic, Suite;
            }
            action("Participation Certificate")
            {
                Caption = 'Participation Certificate';
                RunObject = Report "Seminar Participant Cert";
                Image = Report;
                ApplicationArea = Basic, Suite;
            }
            action("Room Resource Per Registration")
            {
                Caption = 'Room Resource Per Registration';
                RunObject = Report "Rooms Per Seminar";
                Image = Report;
                ApplicationArea = Basic, Suite;
            }
            action("Instructor Resource Per Registration")
            {
                Caption = 'Instructor Resource Per Registration';
                RunObject = Report "Instructor Per Seminar";
                Image = Report;
                ApplicationArea = Basic, Suite;
            }
            action("Incomes Per Seminar")
            {
                Caption = 'Incomes Per Seminar Registration';
                RunObject = Report "Total Invoice Per Seminar";
                Image = Report;
                ApplicationArea = Basic, Suite;
            }
            action("Registrations Per Date")
            {
                Caption = 'Seminar Registrations';
                RunObject = Report "Seminar Per StartDate";
                Image = Report;
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

profile SeminarManager
{
    ProfileDescription = 'Seminar Manager';
    Caption = 'Seminar Manager';
    RoleCenter = "Seminar Manager Role Center";
}