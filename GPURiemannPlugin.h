#ifndef  GPURIEMANNPLUGIN_H
#define GPURIEMANNPLUGIN_H

#include "Plugin.h"
#include "PluginProxy.h"
#include <string>
#include <map>

#include "function.h"

class GPURiemannPlugin : public Plugin {

	public:
		void input(std::string file);
		void run();
		void output(std::string file);
	private:
                std::string inputfile;
		std::string outputfile;
		int N;
		double sum;
		double* a_h;
		double* a_d;
};


#endif
