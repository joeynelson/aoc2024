
function check(value,nums)
    if length(nums) == 1
        return value == nums[1]
    elseif check(value, vcat(nums[1] + nums[2],nums[3:end]))
        return true
    elseif check(value, vcat(nums[1] * nums[2],nums[3:end]))
        return true
    else
        return false
    end
end