/// <summary>
/// Report Seminar Participant Cert (ID 50001).
/// </summary>
report 50001 "Seminar Participant Cert"
{
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Seminar Participation Certificate.rdl';
    Caption = 'Seminar Participation Certificate';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Seminar Registration Header"; "Seminar Registration Header")
        {
            DataItemTableView = SORTING("No.") WHERE("No." = FILTER(<> ''));
            RequestFilterFields = "No.";
            PrintOnlyIfDetail = false;
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
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            dataitem("Seminar Registration Line"; "Seminar Registration Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Seminar Registration Header";
                RequestFilterFields = "Participant Contact No.";
                //PrintOnlyIfDetail = true;
                column(Participant_Contact_No_; "Participant Contact No.")
                {
                }
                column(Participant_Name; "Participant Name")
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
        ParticipantName: Text[100];
        Name: Text[100];
}
