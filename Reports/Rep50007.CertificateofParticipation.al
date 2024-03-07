/// <summary>
/// Report Certificate of Participation (ID 50007).
/// </summary>
report 50007 "Certificate of Participation"
{
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Certificate of Participation.rdl';
    Caption = 'Certificate of Participation';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Seminar Registration Line"; "Seminar Registration Line")
        {
            column(DocumentNo; "Document No.")
            {
            }
            column(LineNo; "Line No.")
            {
            }
            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
            }
            column(ParticipantContactNo; "Participant Contact No.")
            {
            }
            column(ParticipantName; "Participant Name")
            {
            }
            column(ParticipantEMail; "Participant E-Mail")
            {
            }
            dataitem("Seminar Registration Header"; "Seminar Registration Header")
            {
                DataItemLink = "No." = field("Document No.");
                DataItemLinkReference = "Seminar Registration Line";
                DataItemTableView = sorting("No.");

                column(Seminar_No_; "Seminar No.")
                {
                }
                column(SeminarName; "Seminar Name")
                {
                }
                column(StartingDate; "Starting Date")
                {
                }
                column(InstructorName; "Instructor Name")
                {
                }
                column(Room_City; "Room City")
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}
