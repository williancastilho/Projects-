using System;
using System.IO;

public class Logger
{
    private string aPath;
    
    public Logger(string path){
        this.aPath=path;
    }
    
    public string getPath(){
        return this.aPath;
    }
    
    public void writeLog(string message, string level) {
         
        using (StreamWriter xStreamWriter = File.AppendText(getPath()))
        {
            xStreamWriter.WriteLine("[" + DateTime.Now + "] [" + level + "] " + message);
        }
    }

    public static void Main(string[] args)
    {
        Logger xLogger = new Logger(@"C:\temp\app_log.log");

        xLogger.writeLog("User logged in", "INFO");
        
        xLogger.writeLog("Failed login attempt", "WARNING");
        
    }
}