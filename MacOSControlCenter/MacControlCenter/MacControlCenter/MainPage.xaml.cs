using System;
using Microsoft.Maui;
using Microsoft.Maui.Controls;

namespace MacControlCenter
{
	public partial class MainPage : ContentPage
	{
		public MainPage()
		{
			InitializeComponent();
		}

		bool isPlaying = false;
		private void OnPlayClicked(object sender, EventArgs e)
		{
#if MACCATALYST
			var audioService = (IAudioService)MauiUIApplicationDelegate.Current.Services.GetService(typeof(IAudioService));

			if (!isPlaying)
			{
			audioService.Play();
			
			}
			else{
			audioService.Pause();
			}

			isPlaying=!isPlaying;
#endif
		}
	}
}
