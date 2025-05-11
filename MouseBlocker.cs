using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;

class InputBlocker
{
    private const int WH_KEYBOARD_LL = 13;
    private const int WH_MOUSE_LL = 14;
    private const int HC_ACTION = 0;
    private const int VK_ESCAPE = 0x1B;

    private static IntPtr keyboardHookID = IntPtr.Zero;
    private static IntPtr mouseHookID = IntPtr.Zero;

    public static void Main()
    {
        try
        {
            // Set hooks for keyboard and mouse
            keyboardHookID = SetKeyboardHook(KeyboardHookCallback);
            mouseHookID = SetMouseHook(MouseHookCallback);

            Console.WriteLine("Keyboard and Mouse input blocked. Press Ctrl+C to exit.");

            // Keep the program running to block input
            while (true)
            {
                Thread.Sleep(100); // Prevent high CPU usage
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"An error occurred: {ex.Message}");
        }
        finally
        {
            // Clean up hooks when the program ends
            UnhookWindowsHookEx(keyboardHookID);
            UnhookWindowsHookEx(mouseHookID);
        }
    }

    // Keyboard hook procedure
    private static IntPtr KeyboardHookCallback(int nCode, IntPtr wParam, IntPtr lParam)
    {
        if (nCode >= HC_ACTION)
        {
            // Block all keyboard inputs (including ESC key, but can be modified)
            return (IntPtr)1; // Returning 1 blocks the key press
        }
        return CallNextHookEx(keyboardHookID, nCode, wParam, lParam);
    }

    // Mouse hook procedure
    private static IntPtr MouseHookCallback(int nCode, IntPtr wParam, IntPtr lParam)
    {
        if (nCode >= HC_ACTION)
        {
            // Block all mouse actions
            return (IntPtr)1; // Returning 1 blocks the mouse action
        }
        return CallNextHookEx(mouseHookID, nCode, wParam, lParam);
    }

    // Set keyboard hook
    private static IntPtr SetKeyboardHook(LowLevelKeyboardProc proc)
    {
        using (Process curProcess = Process.GetCurrentProcess())
        using (ProcessModule curModule = curProcess.MainModule)
        {
            return SetWindowsHookEx(WH_KEYBOARD_LL, proc, GetModuleHandle(curModule.ModuleName), 0);
        }
    }

    // Set mouse hook
    private static IntPtr SetMouseHook(LowLevelMouseProc proc)
    {
        using (Process curProcess = Process.GetCurrentProcess())
        using (ProcessModule curModule = curProcess.MainModule)
        {
            return SetWindowsHookEx(WH_MOUSE_LL, proc, GetModuleHandle(curModule.ModuleName), 0);
        }
    }

    // Delegates for the keyboard and mouse hooks
    private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);
    private delegate IntPtr LowLevelMouseProc(int nCode, IntPtr wParam, IntPtr lParam);

    // P/Invoke declarations
    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr GetModuleHandle(string lpModuleName);
}
