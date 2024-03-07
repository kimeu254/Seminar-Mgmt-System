report 50005 "Instructor Per Seminar"
{
    ApplicationArea = All;
    Caption = 'Instructor Resource Per Seminar';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/InstructorResourcePerSeminar.rdl';

    dataset
    {
        dataitem(SeminarRegistrationHeader; "Seminar Registration Header")
        {
            RequestFilterFields = "Instructor Resource No.";

            column(No; "No.")
            {
            }
            column(SeminarNo; "Seminar No.")
            {
            }
            column(SeminarName; "Seminar Name")
            {
            }
            column(StartingDate; "Starting Date")
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(InstructorResourceNo; "Instructor Resource No.")
            {
            }
            column(InstructorName; "Instructor Name")
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
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
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[100];
}
