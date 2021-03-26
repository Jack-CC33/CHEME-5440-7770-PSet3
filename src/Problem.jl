# ----------------------------------------------------------------------------------- #
# Copyright (c) 2018 Varnerlab
# Robert Frederick Smith School of Chemical and Biomolecular Engineering
# Cornell University, Ithaca NY 14850
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# ----------------------------------------------------------------------------------- #

# ----------------------------------------------------------------------------------- #
# Function: generate_problem_dictionary
# Description: Holds simulation and model parameters as key => value pairs in a Julia Dict()
# Generated on: 2018-03-15T00:00:56.939
#
# Output arguments:
# data_dictionary::Dict{AbstractString,Any} => Dictionary holding model and simulation parameters as key => value pairs
# ----------------------------------------------------------------------------------- #
function generate_problem_dictionary()

	# Load the stoichiometric network from disk -
	path_to_network_file = joinpath(_PATH_TO_CONFIG,"Network.dat")
	stoichiometric_matrix = readdlm(path_to_network_file, ',', Int, '\n');

	# What is the system dimension? -
	(number_of_species,number_of_reactions) = size(stoichiometric_matrix)

	# Setup the flux bounds array -
	flux_bounds_array = zeros(number_of_reactions,2)
	# TODO: update the flux_bounds_array for each reaction in your network
	flux_bounds_array[1,:] = [0, 3.1716]		# [mmol/gDW*hr] Bounds for v1 flux  E.C. 2.1.3.3
	flux_bounds_array[2,:] = [0, 7.308]			# [mmol/gDW*hr] Bounds for v2 flux  E.C. 6.3.4.5
	flux_bounds_array[3,:] = [0, 1.242]			# [mmol/gDW*hr] Bounds for v3 flux  E.C. 4.3.2.1
	flux_bounds_array[4,:] = [0, 8.964]			# [mmol/gDW*hr] Bounds for v4 flux  E.C. 3.5.3.1
	flux_bounds_array[5,:] = [-0.4932, 0.4932]	# [mmol/gDW*hr] Bounds for v5 flux  E.C. 1.14.13.39
	flux_bounds_array[6:19, 1] .= 0    			# [mmol/gDW*hr]  lower bound on exchange fluxes
	flux_bounds_array[6:19, 2] .= 10   			# [mmol/gDW*hr]  upper bound on exchange fluxes

	# Setup default species bounds array -
	species_bounds_array = zeros(number_of_species,2)
	# TODO: NOTE - we by default assume Sv = 0, so species_bounds_array should be a M x 2 array of zeros
	# TODO: however, if you formulate the problem differently you *may* need to change this 
	#    Is this why I'm not getting a result?  I kind of doubt it.

	# Min/Max flag - default is minimum -
	is_minimum_flag = true

	# Setup the objective coefficient array -
	objective_coefficient_array = zeros(number_of_reactions)
	# TODO: update me to maximize Urea production (Urea leaving the virtual box) 
	# TODO: if is_minimum_flag = true => put a -1 in the index for Urea export
	objective_coefficient_array[17] = -1  # Urea Export:  b12 at rxn index 17 (see Network_Details.dat)
	
	
	# =============================== DO NOT EDIT BELOW THIS LINE ============================== #
	data_dictionary = Dict{String,Any}()
	data_dictionary["stoichiometric_matrix"] = stoichiometric_matrix
	data_dictionary["objective_coefficient_array"] = objective_coefficient_array
	data_dictionary["flux_bounds_array"] = flux_bounds_array;
	data_dictionary["species_bounds_array"] = species_bounds_array
	data_dictionary["is_minimum_flag"] = is_minimum_flag
	data_dictionary["number_of_species"] = number_of_species
	data_dictionary["number_of_reactions"] = number_of_reactions
	# =============================== DO NOT EDIT ABOVE THIS LINE ============================== #
	return data_dictionary
end
