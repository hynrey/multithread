{
Copyright (c) 2020, Loginov Dmitry Sergeevich
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}

unit MTUtils;

interface

uses
  Windows, SysUtils, Classes, Contnrs, SyncObjs, DateUtils, StrUtils, 
  Math, TimeIntervals;

type
  TThreadAccessTerminated = class(TThread);

  // ��������� ������ ����, ��� ��������� TObjectList
  TObjectListHelp = class(Contnrs.TObjectList);


// ������� ������ ����������� ����� � ������ ������ � ��������� �������� Terminate
procedure ThreadWaitTimeout(AThread: TThread; ATimeout: Integer);

// �������� �������� ������
procedure EmulateUsefullWork(WorkTime: Integer);

procedure ThreadShowMessageFmt(Msg: string; Args: array of const);
procedure ThreadShowMessage(Msg: string);

var
  StringProtectSection: TCriticalSection;

implementation

procedure ThreadShowMessage(Msg: string);
begin
  Windows.MessageBox(0, PChar(Msg), '', MB_OK);
end;

procedure ThreadShowMessageFmt(Msg: string; Args: array of const);
begin
  ThreadShowMessage(Format(Msg, Args));
end;

procedure EmulateUsefullWork(WorkTime: Integer);
begin
  Sleep(WorkTime);
end;

// ����������, ���������� �� ������� GetTickCount
{procedure ThreadWaitTimeout(AThread: TThread; ATimeout: Integer);
var
  StartTime, Diff, tc: Cardinal;
  T: TThreadAccessTerminated;
begin
  // �������� ������ � protected-�������� Terminated
  T := TThreadAccessTerminated(AThread);
  // ���� ����� ����� ���������, �� ����� ������� �� �����
  if T.Terminated then Exit;

  // ���������� ������� ����� (� ������������� �� ��������� ����������)
  StartTime := GetTickCount;
  while True do
  begin
    tc := GetTickCount;

    // ��������� ��������, ���� ������� GetTickCount ������ ����� ����
    // ����� ���� ������� �������� ����� ���������
    if (tc < StartTime) then Exit;

    // ��������� ��������, ���� ��������� ��������� �������
    Diff := tc - StartTime;
    if (Diff >= ATimeout) or T.Terminated then
      Exit;

    // ������������ ����� �������� �� 20 ��
    Sleep(20);
  end;
end; }

// ����������, ���������� �� TPerformance
procedure ThreadWaitTimeout(AThread: TThread; ATimeout: Integer);
var
  p: TTimeInterval;
  T: TThreadAccessTerminated;
begin
  // �������� ������ � protected-�������� Terminated
  T := TThreadAccessTerminated(AThread);
  // ���� ����� ����� ���������, �� ����� ������� �� �����
  if T.Terminated then Exit;

  p.Start; // �������� ����� �������
  while True do
  begin
    if T.Terminated or (p.ElapsedMilliseconds >= ATimeout) then
      Exit;
    // ������������ ����� �������� �� 10 ��
    Sleep(10);
  end;
end;

initialization
  // ����������� ������ ��� ������ ����� ��
  // �������������� ������� �� ������ �������
  StringProtectSection := TCriticalSection.Create;

finalization
  StringProtectSection.Free;
end.
